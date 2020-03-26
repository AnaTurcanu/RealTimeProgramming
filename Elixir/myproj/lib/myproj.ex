defmodule Myproj do

  def hello do
    IO.puts "Hello World"
    IO.puts "haide odata"
    url = "http://localhost:4000/iot"



    case HTTPoison.get(url) do
      {:ok, %HTTPoison.Response{status_code: 200, body: body}} ->
        IO.puts body

      {:ok, %HTTPoison.Response{status_code: 404}} ->
        IO.puts "Not found :("
      {:error, %HTTPoison.Error{reason: reason}} ->
        IO.inspect reason
    end
 serializedJson=JSON.encode(HTTPoison.Response)

#response = HTTPoison.get!(url)

#{status, list} = JSON.decode(response)


#Poison.decode!(response)
#IO.inspect(response)

#IO.puts (response)
#req = Poison.decode!(response.body)
  end
end
