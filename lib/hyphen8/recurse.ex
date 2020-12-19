defmodule Hyphen8.Recurse do
@moduledoc false


    def main(data, []) do
        data = Tuple.to_list(data)
        unless Enum.at(data, -3) == "-" do
            data
        else
            List.delete_at(data, -3)
        end
    end

    def main(data, indices) do
        put_elem(data, hd(indices), "-")
        |> main(tl(indices))
    end

end
