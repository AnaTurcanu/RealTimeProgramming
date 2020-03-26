defmodule HttpClient do
  def hello do
    response = HTTPoison.get!("localhost:4000/iot")

    parsedJson = String.split(response.body, "\n\n")

    parsedJsonWithoutFirst = Enum.drop(parsedJson, 1)

    elements = Enum.take_every(parsedJsonWithoutFirst, 2)

    elementsWithoutPanic = Enum.filter(elements, fn x ->
      !String.starts_with?(x, "data: {\"message\": panic")
    end)    
    
    forecasts = Enum.map(elementsWithoutPanic, fn x ->
      trimmedElement = String.replace_suffix(String.replace_leading(x, "data: {\"message\": ", ""), "}", "")
      Poison.decode!(trimmedElement, as: %Forecast{})
    end)

    while(forecasts)
  end

  def printForecast(forecast) do
    IO.puts "Data:"
    IO.puts "Temperature Sensor 1\t #{forecast.temperature_sensor_1}"
    IO.puts "Temperature Sensor 2\t #{forecast.temperature_sensor_2}"
    IO.puts "Humidity Sensor 1\t #{forecast.humidity_sensor_1}"
    IO.puts "Humidity Sensor 2\t #{forecast.humidity_sensor_2}"
    IO.puts "Wind Speed Sensor 1\t #{forecast.wind_speed_sensor_1}"
    IO.puts "Wind Speed Sensor 2\t #{forecast.wind_speed_sensor_2}"
    IO.puts "Atmo Pressure Sensor 1\t #{forecast.atmo_pressure_sensor_1}"
    IO.puts "Atmo Pressure Sensor 2\t #{forecast.atmo_pressure_sensor_2}"
    IO.puts "Light Sensor 1\t\t #{forecast.light_sensor_1}"
    IO.puts "Light Sensor 2\t\t #{forecast.light_sensor_2}"
    IO.puts "Timestamp\t\t #{forecast.unix_timestamp_us}"
    IO.puts "------------------------------------------------------------"
    IO.puts "Average Data:"
    averageTemperature = (forecast.temperature_sensor_1 + forecast.temperature_sensor_2) / 2
    averageHumidity = (forecast.humidity_sensor_1 + forecast.humidity_sensor_2) / 2
    averageWindSpeed = (forecast.wind_speed_sensor_1 + forecast.wind_speed_sensor_2) / 2
    averageAtmoPressure = (forecast.atmo_pressure_sensor_1 + forecast.atmo_pressure_sensor_2) / 2
    averageLight = (forecast.light_sensor_1 + forecast.light_sensor_1) / 2
    IO.puts "Temperature #{averageTemperature}"
    IO.puts "Humidity #{averageHumidity}"
    IO.puts "Wind Speed #{averageWindSpeed}"
    IO.puts "Atmo Pressure #{averageAtmoPressure}"
    IO.puts "Light #{averageLight}"
    IO.puts "------------------------------------------------------------"
    IO.puts "Forecast:"
    evaluateForecast(averageTemperature, averageHumidity, averageWindSpeed, averageAtmoPressure, averageLight)
  end

  def evaluateForecast(temperature, humidity, wind_speed, atmo_pressure, light) do
    
    cond do
      # "if temperature < -2 and light < 128 and athm_pressure < 720 then SNOW",
      temperature < -2 and light < 128 and atmo_pressure < 720 -> IO.puts "SNOW"
      
      # "if temperature < -2 and light > 128 and athm_pressure < 680 then WET_SNOW",
      temperature < -2 and light > 128 and atmo_pressure < 680 -> IO.puts "WET_SNOW"
      
      # "if temperature < -8 then SNOW",
      temperature < -8 -> IO.puts "SNOW"

      # "if temperature < -15 and wind_speed > 45 then BLIZZARD",
      temperature < -15 and wind_speed > 45 -> IO.puts "BLIZZARD"

      # "if temperature > 0 and athm_pressure < 710 and humidity > 70 and wind_speed < 20 then SLIGHT_RAIN",
      temperature > 0 and atmo_pressure < 710 and humidity > 70 and wind_speed < 20 -> IO.puts "SLIGHT_RAIN"

      # "if temperature > 0 and athm_pressure < 690 and humidity > 70 and wind_speed > 20 then HEAVY_RAIN",
      temperature > 0 and atmo_pressure < 690 and humidity > 70 and wind_speed > 20 -> IO.puts "HEAVY_RAIN"
      
      # "if temperature > 30 and athm_pressure < 770 and humidity > 80 and light > 192 then HOT",
      temperature > 30 and atmo_pressure < 770 and humidity > 80 and light > 192 -> IO.puts "HOT"

      # "if temperature > 30 and athm_pressure < 770 and humidity > 50 and light > 192 and wind_speed > 35 then CONVECTION_OVEN",
      temperature > 30 and atmo_pressure < 770 and humidity > 50 and light > 192 and wind_speed > 35 -> IO.puts "CONVECTION_OVEN"

      # "if temperature > 25 and athm_pressure < 750 and humidity > 70 and light < 192 and wind_speed < 10 then WARM",
      temperature > 25 and atmo_pressure < 750 and humidity > 70 and light < 192 and wind_speed < 10 -> IO.puts "WARM"

      # "if temperature > 25 and athm_pressure < 750 and humidity > 70 and light < 192 and wind_speed > 10 then SLIGHT_BREEZE",
      temperature > 25 and atmo_pressure < 750 and humidity > 70 and light < 192 and wind_speed > 10 -> IO.puts "SLIGHT_BREEZE"

      # "if light < 128 then CLOUDY",
      light < 128 -> IO.puts "CLOUDY"

      # "if temperature > 30 and athm_pressure < 660 and humidity > 85 and wind_speed > 45 then MONSOON",
      temperature > 30 and atmo_pressure < 660 and humidity > 85 and light > 45 -> IO.puts "MONSOON"
      
      true -> IO.puts "JUST_A_NORMAL_DAY"
    end
  end
  
  def while(forecasts) do
    index = String.to_integer(String.trim(IO.gets "Enter the index of forecast you would like to visualize(1 - #{Enum.count(forecasts)}): "))
    forecast = Enum.fetch!(forecasts, index - 1)
    printForecast(forecast)
    while(forecasts)
  end
end
