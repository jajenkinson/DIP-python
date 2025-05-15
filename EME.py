import numpy as np
import cv2  # OpenCV library for image processing
import os  # For handling file paths

print(np.__version__)

def compute_eme_metric(image, block_size, save_grayscale=False, original_image_path=None):
    """
    Compute the EME (Enhancement Measurement Estimation) metric for an image.
    If the input is a color image, it is converted to grayscale before computation.
    Optionally, save the grayscale image if the input was color.

    Parameters:
        image (numpy.ndarray): A 2D array representing a grayscale image 
                               or a 3D array representing a color image (BGR format).
        block_size (tuple): A tuple (L1, L2) representing the size of each block.
        save_grayscale (bool): Whether to save the grayscale image if the input is color.
        original_image_path (str): Path to the original image for naming the grayscale file.

    Returns:
        float: The computed EME metric.
    """
    # Check if the image is color (3D array) or grayscale (2D array)
    if len(image.shape) == 3:  # Color image
        # Convert to grayscale using the luminosity method
        grayscale_image = cv2.cvtColor(image, cv2.COLOR_BGR2GRAY)
        
        # Save the grayscale image if required
        if save_grayscale and original_image_path:
            # Extract the original file name without extension
            file_name, file_extension = os.path.splitext(os.path.basename(original_image_path))
            # Create the new file name for the grayscale image
            grayscale_file_name = f"{file_name}-greyscale{file_extension}"
            # Save the grayscale image
            cv2.imwrite(grayscale_file_name, grayscale_image)
            print(f"Grayscale image saved as: {grayscale_file_name}")
        
        # Use the grayscale image for further processing
        image = grayscale_image

    # Extract block dimensions
    L1, L2 = block_size
    
    # Get image dimensions
    N1, N2 = image.shape
    
    # Calculate the number of blocks in each dimension
    k1 = N1 // L1  # Number of blocks along height
    k2 = N2 // L2  # Number of blocks along width
    
    # Initialize the EME value
    eme = 0.0
    
    # Loop through each block
    for k in range(k1):
        for l in range(k2):
            # Get the (k, l)-th block
            block = image[k*L1:(k+1)*L1, l*L2:(l+1)*L2]
            
            # Calculate max and min of the block
            max_val = np.max(block)
            min_val = np.min(block)
            
            # Avoid division by zero
            if min_val > 0:
                # Compute the log ratio for the current block
                eme += 20 * np.log10(max_val / min_val)
    
    # Average EME over all blocks
    eme /= (k1 * k2)
    
    return eme

if __name__ == "__main__":
    # Get the image path from the user
    image_path = input("Enter the path to the image: ")

    # Read the input image using OpenCV
    image = cv2.imread("images/Bear-morning-stretch.jpg")

    # Check if the image was loaded successfully
    if image is None:
        print("Error: Unable to load the image. Make sure the path is correct.")
        exit(1)
    
    # Define the block size (e.g., 16x16)
    block_size = (16, 16)
    
    # Compute the EME metric
    eme_metric = compute_eme_metric(image, block_size, save_grayscale=True, original_image_path=image_path)
    print(f"EME Metric: {eme_metric}")