<html>
        <head>
                <link href='https://fonts.googleapis.com/css?family=Montserrat:100' rel='stylesheet' type='text/css'>
                <style>
                        p { font-family: 'Montserrat', sans-serif; }
                        .clear { clear:both; }
                        .photo-link { padding:5px; margin:10px;  display:block; width:300px; float:left; }
                        .photo-link:hover { border-color:#999; }
                        .center { width: 60%; margin: 0 auto; }
                        .header { width: 60%; margin: 0 auto; padding: 20px; }
                        .profile_pic { float: left; }
                        .profile { display:inline-block; margin-left: 50px; }
                        .username { font-size: 20px; margin: 5px; margin-bottom: 0px; }
                        .name { font-size: 16px; margin: 5px; font-weight: lighter; }
                        .bio, .stats { margin: 5px; font-size: 16px; }
                        .strong { font-weight: bold; }
                        .header img { border-radius: 50%; width: 120px; }
                </style>
        </head>
        <body>
                <div class='center'>
                        <div class='header'>
                                <?php
                                        include('profile.html');
                                ?>
                        </div>
                        <?php
                                $count = 0;
                                foreach (array_reverse(glob("*.jpg")) as $file) {
                                        $thumbnail = "thumbnails/thumb_".$file;
                                        $count++;
                                        if(!file_exists($thumbnail)) {
                                                $source_image = imagecreatefromjpeg($file);
                                                $width = imagesx($source_image);
                                                $height = imagesy($source_image);
                                                $desired_height = floor($height*(300/$width));
                                                $virtual_image = imagecreatetruecolor(300,$desired_height);
                                                imagecopyresized($virtual_image,$source_image,0,0,0,0,300,$desired_height,$width,$height);
                                                imagejpeg($virtual_image,$thumbnail);
                                        }

                                        echo '<a href="',$file,'" class="photo-link" rel="gallery"><img src="',$thumbnail,'" /></a>';

                                        if ($count % 3 == 0) {
                                                echo '<div class="clear"></div>';
                                        }
                                }
                                echo '<div class="clear"></div>';
                        ?>
                </div>
        </body>
</html>
