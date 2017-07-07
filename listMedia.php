<?php
					$directoryMedia = '../media';
					$directories = scandir($directoryMedia, SCANDIR_SORT_DESCENDING);

					foreach ($directories as $key => $folderMedia) {
						if ($folderMedia === '.' || $folderMedia === '..' || $folderMedia === 'logs') continue;

						echo '<br /><br /><h2>'.explode('_', $folderMedia)[0].' '.str_replace('-', ' ', explode('_', $folderMedia)[1]).'</h2><div class="image-row"><div class="image-set">';

						$path = $directoryMedia.'/'.$folderMedia;
						$directoryPics = $path.'/jpg';
						$directoryThumbs = $path.'/thumbs';
						$directoryMovies = $path.'/mp4';
						$directoryZips = $path.'/zip';

						if ($handlePics = opendir($directoryPics)) {
							while (false !== ($filePic = readdir($handlePics))) {
								if ($filePic === '.' || $filePic === '..') continue;
								echo '<a class="example-image-link" href="'.$directoryPics.'/'.$filePic.'" data-lightbox="'.$folderMedia.'"><img class="example-image" src="'.$directoryThumbs.'/'.$filePic.'" alt=""></a>';
							}
							closedir($handlePics);
						}

						if ($handleMovies = opendir($directoryMovies)) {
							while (false !== ($fileMovie = readdir($handleMovies))) {
								if ($fileMovie === '.' || $fileMovie === '..') continue;
								echo '<video width="350" height="275" data-lightbox="'.$folderMedia.'" src="'.$directoryMovies.'/'.$fileMovie.'" controls></video>';
							}
							closedir($handleMovies);
						}

						echo '<br /><b>Downloads</b><br />';

						if ($handleZips = opendir($directoryZips)) {
							while (false !== ($fileZip = readdir($handleZips))) {
								if ($fileZip === '.' || $fileZip === '..') continue;
								echo '<a href="'.$directoryZips.'/'.$fileZip.'">['.strtoupper(substr($fileZip, strrpos($fileZip, "[") + 1 ,3)).'&nbsp-&nbsp'.convertFilesize(getFilesize($directoryZips.'/'.$fileZip)).']</a>&nbsp';
							}
							closedir($handleZips);
						}
					}
					closedir($handleMedia);
					
					echo '</div></div>';

					function getFilesize($file)
					{
						$cmd = 'stat -c%s "'.$file.'"';
						@exec($cmd, $output);
						if (is_array($output) && ctype_digit($size = trim(implode("\n", $output)))) return $size;
						// if all else fails
						return filesize($file);
					}

					function convertFilesize($bytes) {
						$bytes = floatval($bytes);
							$arBytes = array(
								0 => array(
									"UNIT" => "TB",
									"VALUE" => pow(1024, 4)
								),
								1 => array(
									"UNIT" => "GB",
									"VALUE" => pow(1024, 3)
								),
								2 => array(
									"UNIT" => "MB",
									"VALUE" => pow(1024, 2)
								),
								3 => array(
									"UNIT" => "KB",
									"VALUE" => 1024
								),
								4 => array(
									"UNIT" => "B",
									"VALUE" => 1
								),
							);

						foreach($arBytes as $arItem)
						{
							if($bytes >= $arItem["VALUE"])
							{
								$result = $bytes / $arItem["VALUE"];
								$result = str_replace(".", "," , strval(round($result, 2)))." ".$arItem["UNIT"];
								break;
							}
						}
						return $result;
					}
				?>s
