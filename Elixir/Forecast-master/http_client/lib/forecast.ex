defmodule Forecast do
    defstruct [
        :temperature_sensor_1,
        :temperature_sensor_2,
        :humidity_sensor_1,
        :humidity_sensor_2,
        :wind_speed_sensor_1,
        :wind_speed_sensor_2,
        :atmo_pressure_sensor_1,
        :atmo_pressure_sensor_2,
        :light_sensor_1,
        :light_sensor_2,
        :unix_timestamp_us
    ]
end