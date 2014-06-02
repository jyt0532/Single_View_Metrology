Single View Metrology
===============================================

##Steps
1. For the above image of the north quad, estimate the three major orthogonal vanishing points. Use at least three manually selected lines to solve for each vanishing point. This MATLAB code provides an interface for selecting and drawing the lines, but the code for computing the vanishing point needs to be inserted. For details on estimating vanishing points, see Derek Hoiem's book chapter (section 4). You should also refer to this chapter and the single-view metrology lecture for details on the subsequent steps. In your report, you should:
    Plot the VPs and the lines used to estimate them on the image plane using the provided code.
    Specify the VP pixel coordinates.
    Plot the ground horizon line and specify its parameters in the form a * x + b * y + c = 0. Normalize the parameters so that: a^2 + b^2 = 1.

2. Using the fact that the vanishing directions are orthogonal, solve for the focal length and optical center (principal point) of the camera. Show all your work.

3. Compute the rotation matrix for the camera, setting the vertical vanishing point as the Y-direction, the right-most vanishing point as the X-direction, and the left-most vanishing point as the Z-direction.

4. Estimate the heights of (a) the CSL building, (b) the spike statue, and (c) the lamp posts assuming that the person nearest to the spike is 5ft 6in tall. In the report, show all the lines and measurements used to perform the calculation. How do the answers change if you assume the person is 6ft tall?
