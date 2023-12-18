#pragma region hello_world_example
// O------------------------------------------------------------------------------O
// | Trying to get continous game of life working (primordia)                                     |
// O------------------------------------------------------------------------------O

#define OLC_PGE_APPLICATION
#include "olcPixelGameEngine.h"
#include <cstdlib>
#include <vector>
#include <iostream>
#include <algorithm>
#include <cmath>
#include <omp.h>
#include <algorithm>
using namespace std;

class OrbiumPattern
{
public:
	vector<vector<float>> cells = {
		{0, 0, 0, 0, 0, 0, 0.1, 0.14, 0.1, 0, 0, 0.03, 0.03, 0, 0, 0.3, 0, 0, 0, 0},
		{0, 0, 0, 0, 0, 0.08, 0.24, 0.3, 0.3, 0.18, 0.14, 0.15, 0.16, 0.15, 0.09, 0.2, 0, 0, 0, 0},
		{0, 0, 0, 0, 0, 0.15, 0.34, 0.44, 0.46, 0.38, 0.18, 0.14, 0.11, 0.13, 0.19, 0.18, 0.45, 0, 0, 0},
		{0, 0, 0, 0, 0.06, 0.13, 0.39, 0.5, 0.5, 0.37, 0.06, 0, 0, 0, 0.02, 0.16, 0.68, 0, 0, 0},
		{0, 0, 0, 0.11, 0.17, 0.17, 0.33, 0.4, 0.38, 0.28, 0.14, 0, 0, 0, 0, 0, 0.18, 0.42, 0, 0},
		{0, 0, 0.09, 0.18, 0.13, 0.06, 0.08, 0.26, 0.32, 0.32, 0.27, 0, 0, 0, 0, 0, 0, 0.82, 0, 0},
		{0.27, 0, 0.16, 0.12, 0, 0, 0, 0.25, 0.38, 0.44, 0.45, 0.34, 0, 0, 0, 0, 0, 0.22, 0.17, 0},
		{0, 0.07, 0.2, 0.02, 0, 0, 0, 0.31, 0.48, 0.57, 0.6, 0.57, 0, 0, 0, 0, 0, 0, 0.49, 0},
		{0, 0.59, 0.19, 0, 0, 0, 0, 0.2, 0.57, 0.69, 0.76, 0.76, 0.49, 0, 0, 0, 0, 0, 0.36, 0},
		{0, 0.58, 0.19, 0, 0, 0, 0, 0, 0.67, 0.83, 0.9, 0.92, 0.87, 0.12, 0, 0, 0, 0, 0.22, 0.07},
		{0, 0, 0.46, 0, 0, 0, 0, 0, 0.7, 0.93, 1, 1, 1, 0.61, 0, 0, 0, 0, 0.18, 0.11},
		{0, 0, 0.82, 0, 0, 0, 0, 0, 0.47, 1, 1, 0.98, 1, 0.96, 0.27, 0, 0, 0, 0.19, 0.1},
		{0, 0, 0.46, 0, 0, 0, 0, 0, 0.25, 1, 1, 0.84, 0.92, 0.97, 0.54, 0.14, 0.04, 0.1, 0.21, 0.05},
		{0, 0, 0, 0.4, 0, 0, 0, 0, 0.09, 0.8, 1, 0.82, 0.8, 0.85, 0.63, 0.31, 0.18, 0.19, 0.2, 0.01},
		{0, 0, 0, 0.36, 0.1, 0, 0, 0, 0.05, 0.54, 0.86, 0.79, 0.74, 0.72, 0.6, 0.39, 0.28, 0.24, 0.13, 0},
		{0, 0, 0, 0.01, 0.3, 0.07, 0, 0, 0.08, 0.36, 0.64, 0.7, 0.64, 0.6, 0.51, 0.39, 0.29, 0.19, 0.04, 0},
		{0, 0, 0, 0, 0.1, 0.24, 0.14, 0.1, 0.15, 0.29, 0.45, 0.53, 0.52, 0.46, 0.4, 0.31, 0.21, 0.08, 0, 0},
		{0, 0, 0, 0, 0, 0.08, 0.21, 0.21, 0.22, 0.29, 0.36, 0.39, 0.37, 0.33, 0.26, 0.18, 0.09, 0, 0, 0},
		{0, 0, 0, 0, 0, 0, 0.03, 0.13, 0.19, 0.22, 0.24, 0.24, 0.23, 0.18, 0.13, 0.05, 0, 0, 0, 0},
		{0, 0, 0, 0, 0, 0, 0, 0, 0.02, 0.06, 0.08, 0.09, 0.07, 0.05, 0.01, 0, 0, 0, 0, 0}};
};

class Example : public olc::PixelGameEngine
{
public:
	Example()
	{
		sAppName = "Lenia Orbium";
	}

	int size = 100;
	float T = 9.0f;
	static const int R = 13;
	static const int kernelSize = 2 * R + 1;
	float K[kernelSize][kernelSize];
	int scale = 1;
	int cx, cy = 20;

	OrbiumPattern orbiumPattern;

	void placePattern(int cx, int cy, int scale)
	{
		for (int i = 0; i < orbiumPattern.cells.size(); ++i)
		{
			for (int j = 0; j < orbiumPattern.cells[i].size(); ++j)
			{
				int scaled_i = i * scale;
				int scaled_j = j * scale;
				if (scaled_i + cx < size && scaled_j + cy < size)
				{
					grid[(scaled_i + cx) * size + (scaled_j + cy)] = orbiumPattern.cells[i][j];
				}
			}
		}
	}

	std::vector<olc::Pixel> colorPalette = {
		olc::BLACK,	   // Dead cell (state 0)
		olc::DARK_RED, // Close to death (state 1)
		olc::RED,	   .
		olc::DARK_YELLOW,
		olc::YELLOW,
		olc::Pixel(233, 116, 81), // orange
		olc::Pixel(255, 215, 0),  // gold
		olc::GREEN,
		olc::DARK_GREEN,
		olc::CYAN,
		olc::BLUE,
		olc::DARK_BLUE,
		olc::Pixel(128, 0, 128), // ...
		olc::MAGENTA,			 // Close to life (state 12)
		olc::WHITE				 // Fully alive (state 13)
	};

	float clip(float n, float lower, float upper)
	{
		return max(lower, min(n, upper));
	}

private:
	vector<float> initialGrid;
	vector<float> grid;
	vector<float> tempGrid;

	// Bell function
	float bell(float x, float m, float s)
	{
		return exp(-pow((x - m) / s, 2.0f) / 2.0f);
	}

	float growth(float U)
	{
		// discrete growth function works
		return ((U >= 0.12) & (U <= 0.15)) - ((U < 0.12) | (U > 0.15));

		// float m = 0.135f;
		// float s = 0.015f;
		// return bell(U, m, s) * 2.0f - 1.0f;
		// float m = 0.135f;					 // Adjust this value
		// float s = 0.02f;					 // Adjust this value
		// return bell(U, m, s) * 1.0f - 0.5f; // Adjust scaling and offset
	}

	void initKernel()
	{
		float K_sum = 0.0f;
		for (int i = -R; i <= R; ++i)
		{
			for (int j = -R; j <= R; ++j)
			{
				float D = (sqrt(i * i + j * j) + 1) / R;
				K[i + R][j + R] = (D < 1) ? bell(D, 0.5f, 0.15f) : 0;
				K_sum += K[i + R][j + R];
			}
		}

		// Normalize the kernel
		for (int i = 0; i < 2 * R + 1; ++i)
		{
			for (int j = 0; j < 2 * R + 1; ++j)
			{
				K[i][j] /= K_sum;
			}
		}
	}

	void convolve2dSameWrap()
	{
		int kernelSize = 2 * R + 1;
		for (int i = 0; i < size; ++i)
		{
			for (int j = 0; j < size; ++j)
			{
				float sum = 0.0f;
				for (int ki = -R; ki <= R; ++ki)
				{
					for (int kj = -R; kj <= R; ++kj)
					{
						int wrapped_i = (i + ki + size) % size;
						int wrapped_j = (j + kj + size) % size;
						sum += grid[wrapped_i * size + wrapped_j] * K[ki + R][kj + R];
					}
				}

				float updatedValue = (grid[i * size + j] + 1.0f / T * growth(sum));
				tempGrid[i * size + j] = clip(updatedValue, 0.0f, 1.0f);
			}
		}
		grid.swap(tempGrid);
	}

public:
	bool OnUserCreate() override
	{
		srand(static_cast<unsigned>(0)); // Matched with Python code
		grid.resize(size * size);
		tempGrid.resize(size * size);
		initialGrid.resize(size * size);

		for (int i = 0; i < size * size; i++)
		{

			// grid[i] = static_cast<float>(rand()) / RAND_MAX;
			grid[i] = 0.0f;
			initialGrid[i] = grid[i];
		}
		placePattern(20, 20, 1);
		placePattern(30, 50, 1);
		placePattern(0, 0, 1);
		// placePattern(78, 80, 1);
		initKernel();
		return true;
	}

	bool OnUserUpdate(float fElapsedTime) override
	{
		convolve2dSameWrap();

		for (int row = 0; row < size; row++)
		{
			for (int col = 0; col < size; col++)
			{
				float state = grid[row * size + col];
				// map grid value to a discrete state for visualization
				int mapped = static_cast<int>(state * 11.0f);
				olc::Pixel color = colorPalette[mapped];
				Draw(row, col, color);
			}

			if (GetKey(olc::Key::R).bPressed)
			{
				ResetGrid();
			}
		}
		return true;
	}
	void ResetGrid()
	{
		grid = initialGrid; // Reset grid to initial state
		placePattern(20, 20, 1);
		placePattern(30, 50, 1);
		placePattern(0, 0, 1);
		// placePattern(78, 80, 1);
	}
};

int main()
{
	Example demo;
	if (demo.Construct(demo.size, demo.size, 4, 4))
	{
		demo.Start();
	}
	return 0;
}