Updated by David Schuftan on 3/22/24

Purpose:
These scripts enable a user to measure the angle of individual sarcomeres against overall tissue geometry and measure the distances between the individual sarcomere z-lines. The first script, sarcomeredistance_shaftangle2.m, uses a GUI to enable user inputs to analyze the sarcomere images and generate the measurements into .mat files. The second script, sarcomercompiler2_shaftangle.m, compiles the .mat files into a single .xlsx with averages and standard deviations.

Scripts:
	sarcomeredistance_shaftangle2.m
	sarcomercompiler2_shaftangle.m

Called Functions:
	bfopen.m

Toolboxes:
	Image Processing Toolbox

Compatible File Types:
	.nd2
	.jpg
	.png
	.tif
	.oif

	-To use .oif filetypes, a folder in the same directory as the .oif file named "[filename].oif.files", where [filename] is the same name as the selected .oif file must exist. Inside the accompanying folder must exist a .tif image that will be analyzed. The name of the .tif image in the folder must be hardcoded into the sarcomeredistance_shaftangle2.m at line 158 as a char that the "file" variable is set to. By default, the string is set to 's_C002.tif'. If multiple .oif files are selected, the images to be analyzed in all of the accompanying folders must have the same name.


	Note: Other file types may be functional as well, but have not been tested.
	

Steps:


1. Run the -sarcomeredistance_shaftangle2.m function in MATLAB.

2. In the file explorer that opens, select the images to be analyzed. 

3. Select the pixel to micron ratio of the image. 
	-If the desired ratio is not listed, select "Custom Scaling Factor". Enter the um/pixel ratio in the subsequent input dialogue box.

4. The analyzer GUI should now open with the image to be analyzed in the left window with the file name listed above. If the image to be analyzed is not a supported file type, the window will be blank and a dialogue warning box stating "File type not compatible! Move to next file." will appear. Select "OK" to move to the next image and repeat this step.

5. Adjust the contrast sliders to change the brightness of the image.

6. When the desired brightness/contrast is set, if the user would like to analyze the image select "Yes" in the "Analyze chosen image?" box. If the user don't want to analyze the image select "No, next image." If there are more images to be analyzed, indicated by the counter in the lower right, the next image will be loaded in and return to step 5.

7. If analyzed the image, the "Measure overall angle?" box will become active. If the user would like to measure the angle of alignment between the overall tissue and individual filaments, select "Yes (Shaft)" and go to Step 8. If the user would like to only measure the distance between z-bands, select "No (Knob)" and go to step 10.

-----For in-depth instructions on the remaining steps continue to step 8. For abbreviated instructions, follow the GUI Command Window until all images are analyzed and go to step 16.-----

8. Draw a line on the image being analyze parallel to the overall tissue direction to serve as a reference line. 

9.If the user wants to continue with the drawn line as the reference line, select "Yes" in the "Use drawn line?" box and continue. If the user would like to redraw the line, select "Redraw" in the "Use drawn line?" box and return to step 8.

10. Draw a line through a filament such that the Z-bands are perpendicular to the drawn line and the line is parallel to the overall direction of the filament. A line plot in the right window will be shown and the "Use drawn line?" box will be active.

11. If the user would like to use the drawn line to measure the distances between adjacent z-bands, select "Yes" in the "Use drawn line?" box and continue. If the user would like to redraw the line, select "No" in the "Use drawn line?" box and return to step 10.

Note: A good line should generate a plot in the right window with evenly spaced peaks indicating the z-bands.

12. Select a point on the right window axes to the left of the left most peak. A red vertical line will be drawn at the point selected.

13. Select another point to the left of the second left most peak and to the right of the left most peak. Another red line will be drawn at the second point picked and a red circle will be drawn at the top of the first peak.

14. Continue selecting points to the left of the next left most peaks, leading to red circles being drawn at the previous peak. When all desired peaks have red circles drawn either select a point to the left of the last point selected or a point outside the axes and the last line will turn cyan indicating the analysis is complete. Alternatively, the last drawn line will automatically turn cyan if the plot continually decreases from the last point selected.

15. When the last line turns cyan the "Reset peaks", "Draw another line", and "Move to next image" buttons will be active. 
	-If a false peak is selected, a peak is skipped, or any other undesirable outcome occurs, select "Rest peaks" and return to step 12. 

	-If the selected peaks are acceptable and the user wants to analyze a different location within the same image, select "Draw another line". The current line will turn green, and the data will be saved. Return to step 10.

	-If the current image is fully analyzed, select "Move to next image". The image in the left window will change to the next file. Return to step 5.

16. When all images are analyzed, the GUI will automatically close, and the script will be complete. A folder titled "Sarcomere Distances" in the directory of the selected files will be created. Inside the folder will be a .mat data for each analyzed image containing the data.

17. To compile the data into a single, easy to read .xlsx, run the sarcomercompiler2_shaftangle.m script.

18. Select all files in the "Sarcomere Distances" folder that the user wants compiled.

19. All of the data from the selected files will now be saved in a .xlsx file title "[Folder Name] Sarcomere Data.xlsx" where [Folder Name] is the name of the original directory folder that the analyzed images and Sarcomere Distances folder are located. 

	-Within the .xlsx file will be n+1 sheets, where n is the number of compiled files. The first tab, titled "Compiled" will have the average data from each of the compiled files. There will additionally be on tab for each image with the data from each line drawn  and the overall averages also shown in the "Compiled" tab.





