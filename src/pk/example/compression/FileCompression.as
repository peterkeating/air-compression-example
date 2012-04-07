package pk.example.compression
{
	import flash.filesystem.File;
	import flash.net.FileReference;
	
	import org.osflash.signals.ISignal;
	import org.osflash.signals.Signal;

	public class FileCompression
	{
		private var _completeSignal: Signal = new Signal(File);
		
		/**
		 * Dispatches when the zipping file has successfully
		 * complete.
		 */
		public function get completeSignal(): ISignal
		{
			return _completeSignal;	
		}
		
		/**
		 * 
		 */
		public function zip(files: Vector.<File>, zipFile: FileReference): void
		{
			
		}
	}
}