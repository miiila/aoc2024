defmodule AocHelper do
  def download_input(day) do
    download("https://adventofcode.com/2024/day/#{day}/input", "day#{day}_input")
  end

  defp download(url, destination) do
    :ok = :inets.start()
    :ok = :ssl.start()

    session = System.get_env("AOC_SESSION")
    cookies = [{~c"Cookie", ~c"session=#{session}"}]

    case :httpc.request(:get, {url, cookies}, [], body_format: :binary) do
      {:ok, {{_, 200, _}, _headers, body}} ->
        File.write!(destination, body)
        IO.puts("File downloaded successfully to #{destination}")

      {:ok, {{_, status_code, _}, _headers, _body}} ->
        IO.puts("Download failed with status code: #{status_code}")

      {:error, reason} ->
        IO.puts("Download error: #{inspect(reason)}")
    end
  end

  def load_input(day, test?, transformer \\ fn x -> x end) do
    path =
      case {day, test?} do
        {_, true} ->
          Path.join([".", "day#{day}_input_test"])

        {_, false} ->
          Path.join([".", "day#{day}_input"])
      end

    File.stream!(path, :line) |> Enum.map(&String.trim/1) |> Enum.map(transformer)
  end

  def getNext({row, col}) do
    [
      {row, col + 1},
      {row + 1, col},
      {row, col - 1},
      {row - 1, col}
    ]
  end

  def getNext(pos, :dir) do
    Enum.zip(getNext(pos), [">","v","<","^"]) 
  end

  # Intentionally switching to x,y , resp. y,x to remind myself it's there and opposite
  def getNext({y, x}, :octo) do
    for dy <- -1..1, dx <- -1..1, do: {y + dy, x + dx}
  end

end
