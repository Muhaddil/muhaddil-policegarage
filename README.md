# Muhaddil Police Garage

A police garage system for FiveM servers, supporting multiple frameworks and offering extensive customization for vehicles, locations, and job restrictions.

## Features
- 🚗 **Multi-Framework Support**: Works with ESX, QBCore, or can be set to "auto" detection.
- 📍 **Multiple Locations**: Pre-configured for Mission Row, Sandy Shores, and Paleto Bay.
- 👮 **Job Restrictions**: Restrict garages to specific jobs (Police, Sheriff, State Police).
- 🎨 **Vehicle Customization**:
  - Custom colors, liveries, and extras.
  - Performance stats display (Speed, Acceleration, Handling, Braking).
  - Categorized vehicle lists (Patrol, SUV, Tactical, Bike, Special, Unmarked).
- 📝 **License Plates**: Automatic plate generation based on job (e.g., LSPD, BCSO, STATE).
- 🖥️ **Modern UI**: Clean HTML/CSS interface for vehicle selection with preview.

## Dependencies
- [ox_lib](https://github.com/CommunityOx/ox_target)

## Installation

1. **Download & Extract**:
   - Download the resource and place it in your `resources` folder.

2. **Database Setup**:
   - Import the `SQL.SQL` file into your server's database. This creates the necessary tables (`police_garage_logs`).

3. **Configuration**:
   - Open `config.lua` to adjust settings:
     - `Config.FrameWork`: Set to "esx", "qb", or "auto".
     - `Config.GarageLocations`: Add or modify garage coordinates.
     - `Config.Vehicles`: Configure available vehicles, prices, and customization options.
     - `Config.OpenKey`: Key to interact (default is 38 - 'E').

4. **Server Config**:
   - Add the following to your `server.cfg`:
     ```cfg
     ensure ox_lib
     ensure muhaddil-policegarage
     ```

## Usage
1. Go to one of the configured garage locations (e.g., Mission Row PD).
2. Look for the marker or blip (if enabled).
3. Press **E** (or configured key) to open the garage menu.
4. Select a vehicle category and choose your vehicle.
5. Customize livery/extras if available and spawn.
6. To store a vehicle, return to the garage marker with the vehicle and press **E**.

## License
This project is licensed under the MIT License.
