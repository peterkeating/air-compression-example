package pk.example.compression
{
	import flash.filesystem.File;
	
	import org.hamcrest.assertThat;
	import org.hamcrest.object.isTrue;
	import org.osflash.signals.utils.SignalAsyncEvent;
	import org.osflash.signals.utils.handleSignal;
	import org.osflash.signals.utils.proceedOnSignal;

	public class FileCompressionTests
	{
		private const TIMEOUT: int = 10000;
		private const ZIP_FILENAME: String = "my-archive.zip";
		
		/**
		 * Zip file that is being created during
		 * the test.
		 */
		private function get zipFile(): File
		{
			return File.applicationStorageDirectory.resolvePath(ZIP_FILENAME);
		}
		
		[After]
		public function before(): void
		{
			// ensure that the zip file is deleted after each test.
			if (zipFile.exists)
				zipFile.deleteFile();
		}
		
		/**
		 * Tests that when the zip has finished, the completeSignal is
		 * dispatched to a method that will assert that the zip file
		 * is present as expected.
		 */
		[Test(async)]
		public function zip_filesAreArchivedInZipFile(): void
		{
			var fileCompression: FileCompression = new FileCompression();
			
			handleSignal(this, fileCompression.completeSignal, assetZipFileExists, TIMEOUT);
			
			fileCompression.zip(dummyFiles(), zipFile);
		}
		
		/**
		 * Proves that the code works by asserting that
		 * the zip file exists.
		 */
		private function assetZipFileExists(e: SignalAsyncEvent, data: Object): void
		{
			assertThat(zipFile.exists, isTrue());
		}
		
		/**
		 * Creates a collection of dummy files.
		 */
		private function dummyFiles(): Vector.<File>
		{
			var files: Vector.<File> = new Vector.<File>();
			files.push(File.applicationDirectory.resolvePath("assets/dummy/random-text.txt"));
			files.push(File.applicationDirectory.resolvePath("assets/dummy/random-image.jpg"));
			files.push(File.applicationDirectory.resolvePath("assets/dummy/random-music.wma"));
			return files;
		}
	}
}