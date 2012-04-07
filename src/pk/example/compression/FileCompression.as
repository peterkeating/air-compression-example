package pk.example.compression
{
	import flash.desktop.NativeProcess;
	import flash.desktop.NativeProcessStartupInfo;
	import flash.events.NativeProcessExitEvent;
	import flash.filesystem.File;
	import flash.net.FileReference;
	
	import org.osflash.signals.ISignal;
	import org.osflash.signals.Signal;

	public class FileCompression
	{
		private const EXE: String = "assets/native/7zip/7za.exe";
		
		private var _completeSignal: Signal = new Signal();
		
		/**
		 * Dispatches when the zipping file has successfully
		 * complete.
		 */
		public function get completeSignal(): ISignal
		{
			return _completeSignal;	
		}
		
		/**
		 * Dispatches the completeSignal to notify
		 * listeners that the compression has been
		 * completed.
		 */
		private function complete(): void
		{
			_completeSignal.dispatch();
		}
		
		/**
		 * Creates the arguments for the native exectuable.
		 */
		private function createArgs(files: Vector.<File>, zipFile: File): Vector.<String>
		{
			var args: Vector.<String> = new Vector.<String>();
			
			// flag tells 7zip to archive
			args.push("a");
			
			// defines to create a .zip acrhive
			args.push("-tzip");
			
			// path to save the zip file to
			args.push(zipFile.nativePath);
			
			// path of all the files to include in the archive
			for each(var file: File in files)
			{
				args.push(file.nativePath);
			}
			
			return args;
		}

		/**
		 * Handles the competition of the native process by disposing
		 * of the NativeProcess instance created, and then dispatched
		 * the complete signal.
		 */
		private function onExit(e: NativeProcessExitEvent): void
		{
			(e.target as NativeProcess).closeInput();
			(e.target as NativeProcess).exit(true);
			
			complete();
		}
		
		/**
		 * Creates a zip file.
		 * 
		 * @filesToArchive 	Collection of files to include in the archive.
		 * @zipFile			.zip file that will be created.
		 */
		public function zip(filesToArchive: Vector.<File>, zipFile: File): void
		{
			var nativeProcessStartupInfo:NativeProcessStartupInfo = new NativeProcessStartupInfo();
			nativeProcessStartupInfo.executable = File.applicationDirectory.resolvePath(EXE);;
			
			nativeProcessStartupInfo.arguments = createArgs(filesToArchive, zipFile);
			
			var nativeProcess: NativeProcess = new NativeProcess();
			nativeProcess.addEventListener(NativeProcessExitEvent.EXIT, onExit);
			nativeProcess.start(nativeProcessStartupInfo);
		}
	}
}