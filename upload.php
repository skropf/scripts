<html>
	<head></head>
	<body>
		<br><br>
		<form action="upload.php" method="post" enctype="multipart/form-data" autocomplete="off" style="line-height: 175%;">
			Files to upload: <input type="file" name="filesToUpload[]" multiple><br>
			Foldername: <input type="text" name="folderName" autocomplete="off"><br>
			Text: <textarea name="text" cols="30" rows="8"></textarea><br>
			<input type="submit" value="Upload Media" name="submit">
		</form>

		<?php
			if(isset($_POST["submit"])) {

				$uploadSuccessful = [];
				$folderName = $_POST["folderName"];
				$text = $_POST["text"];
				$path = "media/".$folderName."/";
				$pathCR2 = $path."cr2/";
				$pathMOV = $path."mov/";



				if ($text == "" || $folderName == "") {
					echo "<font color='red'>Please fill out all fields.</font><br>";
					goto end;
				}

				if (file_exists($path)) {
					echo "<font color='red'>Mediafolder already exists. Choose a new one!</font><br>";
					goto end;
				}
				else {
					mkdir($path, 0755);
					mkdir($pathCR2, 0755);
					mkdir($pathMOV, 0755);
					mkdir($path."jpg", 0755);
					mkdir($path."mp4", 0755);
					mkdir($path."thumbs", 0755);
					mkdir($path."zip", 0755);
				}

				foreach ($_FILES['filesToUpload']['name'] as $i => $name) {
			
					$filePath = $_FILES['filesToUpload']['tmp_name'][$i];
					$fileType = pathinfo($name, PATHINFO_EXTENSION);

					if ($filePath != "" && $fileType == "CR2") {
				
						$uploadComplete = move_uploaded_file($filePath, $pathCR2.$name);

						if($uploadComplete) {
							echo "<font color='green'>The image ".$name." has been uploaded!</font><br>";
							$uploadSuccessful[$i] = 1;
						}
						else {
							echo "<font color='red'>The image ".$name." has NOT been uploaded!</font><br>";
							$uploadSuccessful[$i] = 0;
						}
					}
					else { //for all other files
						echo "<font color='red'>The movie ".$name." has NOT been uploaded, because the filetype is not supported!</font><br>";
					}

					//no movies because ffmpeg converting hangs up the raspi
					/*
					if ($filePath != "" && $fileType == "MOV") {
				
						$uploadComplete = move_uploaded_file($filePath, $pathMOV.$name);

						if($uploadComplete) {
							echo "<font color='green'>The movie ".$name." has been uploaded!</font><br>";
							$uploadSuccessful[$i] = 1;
						}
						else {
							echo "<font color='red'>The movie ".$name." has NOT been uploaded!</font><br>";
							$uploadSuccessful[$i] = 0;
						}
					}
					*/
				}
				if (!empty($uploadSuccessful) && !in_array(0, $uploadSuccessful)) {
					shell_exec("sh scripts/convertMedia.sh ".$folderName." > media/logs/logFile_".$folderName." 2>media/logs/logFileErrors_".$folderName." &");
					echo "The media is now being converted. This <u>will</u> take a while!";
				}
				end:
			}
		?>
	</body>
</html>

