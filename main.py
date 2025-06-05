import cv2
import numpy as np
import numpy as np
from skimage import exposure

def color_to_2x2(gray, r, g, b):
    N, M = gray.shape
    arr_2x2 = np.zeros((2*N, 2*M), dtype=gray.dtype)
    arr_2x2[0::2, 0::2] = gray
    arr_2x2[0::2, 1::2] = b
    arr_2x2[1::2, 0::2] = r
    arr_2x2[1::2, 1::2] = g
    return arr_2x2

def gradient_weighted_he(img2x2):
    # Smooth image
    smooth = cv2.GaussianBlur(img2x2, (3, 3), 0)
    # Gradient magnitude
    grad_x = cv2.Sobel(smooth, cv2.CV_64F, 1, 0, ksize=3)
    grad_y = cv2.Sobel(smooth, cv2.CV_64F, 0, 1, ksize=3)
    grad = np.sqrt(grad_x**2 + grad_y**2)
    grad_norm = grad / grad.max()  # Normalize to [0, 1]
    # Weighted histogram equalization using gradient as weights
    flat = img2x2.flatten()
    weights = grad_norm.flatten() + 1e-6  # avoid zero weights
    # Get histogram with weights
    hist, bin_edges = np.histogram(flat, bins=256, range=(0,255), weights=weights)
    cdf = np.cumsum(hist)
    cdf_normalized = cdf / cdf[-1]
    # Interpolate equalized values
    img2x2_eq = np.interp(flat, bin_edges[:-1], cdf_normalized * 255).reshape(img2x2.shape)
    return img2x2_eq.astype(np.uint8)

def gb_he_2x2_color(img):
    # img: uint8, shape (N, M, 3)
    r, g, b = img[:,:,2], img[:,:,1], img[:,:,0]  # OpenCV uses BGR
    gray = (0.3*r + 0.59*g + 0.11*b).astype(np.uint8)
    arr_2x2 = color_to_2x2(gray, r, g, b)
    arr_2x2_eq = gradient_weighted_he(arr_2x2)
    img_out = inv_2x2_to_color(arr_2x2_eq)
    return img_out

def inv_2x2_to_color(arr_2x2):
    N, M = arr_2x2.shape[0]//2, arr_2x2.shape[1]//2
    gray = arr_2x2[0::2, 0::2]
    b = arr_2x2[0::2, 1::2]
    r = arr_2x2[1::2, 0::2]
    g = arr_2x2[1::2, 1::2]
    out = np.stack([r, g, b], axis=2)
    return out


img = cv2.imread('input2.jpg')  # Read color image
img_out = gb_he_2x2_color(img)
cv2.imwrite('output_gbhe.jpg', img_out)
