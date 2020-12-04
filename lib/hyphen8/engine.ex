defmodule Hyphen8.Engine do

    def main(string) do
        string
        |> parse_words
        |> parse_characters
        |> match_against_key
        |> compile_coords
        |> filter_coords
        |> construct_hyphens
    end

    def parse_words(string) do
        Keyword.new
        |> Keyword.put(:words, String.split(string, ~r/\s|\\n|\\r|\\t|\W|_/, trim: true))
    end

    def parse_characters(data) do
        data
        |> Keyword.put( :characters, Enum.map(data[:words],
           &String.split(&1, ~r/\w/, include_captures: true, trim: true))
        |> Enum.map(&Enum.join(&1, "0"))
        )
    end

    def match_against_key(data) do
        data
        |> Keyword.put_new(:matches, Enum.map(data[:characters], fn word    ->
           Enum.map(Hyphen8.Table.main, fn [regex, _list]                   ->
           Regex.scan(regex, word, return: :index) end)
           |> Enum.reject(&Enum.empty?(&1                     ))
           |> Enum.map(&List.flatten(  &1                     ))
           |> Enum.map(&Enum.map(      &1, fn {a, _b} -> a end))
        end))
        |> Keyword.put_new(:regex, Enum.map(data[:characters], fn word      ->
           Enum.flat_map(Hyphen8.Table.main, fn [regex, list]               ->
             case Regex.match?(regex, word) do
                :true  -> [list]
                :false -> []
             end
           end)
        end))
    end

    def compile_coords(data) do
        Keyword.put_new(data, :coordinates,
           Enum.zip(data[:matches], data[:regex]                             )
        |> Enum.map(&Tuple.to_list(&1))
        |> Enum.map(fn [match, regex] -> Enum.zip(     match, regex          )
        |> Enum.map(&Tuple.to_list(&1))
        |> Enum.map(fn [indices, tuples] -> Enum.map(indices, fn index      ->
           Enum.map(tuples, fn {a, b} -> {(a + index), b}         end)end)end)
        |> Enum.flat_map(&List.flatten(&1))
        end)
        )
    end

    def filter_coords(data) do
        Keyword.update!(data, :coordinates, fn list -> 
           Enum.map(list, &Enum.uniq(&1)
        |> Enum.map(     fn tuple    -> Tuple.to_list(tuple)                 end)
        |> Enum.reject(  fn [  a,_b] -> a == 1                               end)
        |> Enum.group_by(fn [  a,_b] -> a                                    end)
        |> Enum.map(     fn { _k, v} -> 
           Enum.max_by(v,fn [ _a, b] -> b end) end)
        |> Enum.reject(  fn [ _a, b] -> rem(b, 2) == 0                       end)
        )
        end)
    end

    def construct_hyphens(data) do
        data
        |> Keyword.put_new(:hyphenated, 
           Enum.zip(data[:characters], data[:coordinates]                             )
        |> Enum.map(&Tuple.to_list(&1                        ))
        |> Enum.map(fn [word, coords] -> [String.split(word, "", trim: :true), Enum.map(coords, fn [a, _b] -> a end)]end)
        |> Enum.map(fn [word, coords] -> [List.to_tuple(word), coords]      end)
        |> Enum.map(fn [word, coords] -> Hyphen8.Recurse.main(word, coords) end)
        |> Enum.map(&Tuple.to_list(&1                        ))
        |> Enum.map(&Enum.reject(  &1  , fn x -> x == "0" end))
        |> Enum.map(&Enum.join(    &1                        ))
        |> Enum.join(" ")
        )
        |> Keyword.get(:hyphenated)
    end
end
