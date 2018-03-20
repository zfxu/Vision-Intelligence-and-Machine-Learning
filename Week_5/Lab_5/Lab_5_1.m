buildingDir = fullfile(toolboxdir('vision'), 'visiondata', 'building');
buildingScene = imageDatastore(buildingDir);
I1 = readimage(buildingScene, 1);
I2 = readimage(buildingScene, 2);

p1 = [ 366.6972  106.9789
  439.9366   84.4437
  374.5845  331.2042
  428.6690  326.6972 ];

p2 = [ 115.0000  120.0000
  194.0000  107.0000
  109.0000  351.0000
  169.0000  346.0000 ];

figure()
imshow(I1);
hold on;
plot(p1(:,1),p1(:,2),'go')
hold off;

figure()
imshow(I2);
hold on;
plot(p2(:,1),p2(:,2),'go')
hold off;

H = compute_homography(p1,p2);
I = stitch(I1,I2,H);

figure()
imshow(I)
