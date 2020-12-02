defmodule Hyphen8.Recurse do

    def main(data, []) do

        data

    end


    def main(data, indices) do

        put_elem(data, hd(indices), "-")
        |> main(tl(indices))

    end

end
