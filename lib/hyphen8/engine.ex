defmodule Hyphen8.Engine do
    # BUG: make allowances for apostrophes when parsing input
    def main(string) do
        string
        |> parse_words
        |> parse_characters
        |> match_against_key
        |> compile_coords
        |> filter_coords
        |> construct_hyphens
    end

    # BUG: this regex is sloppy garbage. use parsy and really nail parsy down"
    def parse_words(string) do
        Keyword.new
        |> Keyword.put(:words, String.split(string, ~r/ /, trim: true))
    end

    # TODO: use parsy to parse words.
    def parse_characters(data) do
        data
        |> Keyword.put( :characters ,
           Enum.map(    data[:words], fn word -> 
           String.split(word, ~r/\w/, include_captures: true, trim: true)end)
        |> Enum.map(fn x -> Enum.join(x, "0")end)
        |> Enum.map(fn word -> "#{word}0" end)
        )
    end

    def match_against_key(data) do
        data
        |> Keyword.put_new(:matches, Enum.map(data[:characters], fn word    ->
           Enum.flat_map(Hyphen8.Table.main, fn [regex, _list]              ->
           Regex.scan(regex, word, return: :index)
           |> List.flatten() 
           end)
        end))
        |> Keyword.put_new(:regex, Enum.map(data[:characters], fn word      ->
           Enum.flat_map(Hyphen8.Table.main, fn [regex, list]               ->
             case Regex.match?(regex, word) do
                :true  -> [list]
                :false -> []
             end
           end)
        end))
        #   CANT YOU MOVE THIS UP?
        |> Keyword.update!(:matches, fn lists -> Enum.map(lists, fn list    ->
            Enum.map(list, fn {a, _b} -> a end)
        end)end)
    end

    def compile_coords(data) do
        Keyword.put_new(data, :coordinates,
           Enum.zip(data[:matches], data[:regex]                             )
        |> Enum.map(fn tuple          -> Tuple.to_list(tuple             )end)
        |> Enum.map(fn [match, regex] -> Enum.zip(     match, regex          )
        |> Enum.map(fn tuple          -> Tuple.to_list(tuple             )end)
        |> Enum.map(fn [index,tuples] -> Enum.map(     tuples, fn {a, b}    ->
        {(a+index), b} end)end)
        end)
        )
    end

    def filter_coords(data) do
        Keyword.update!(data, :coordinates, fn list -> 
           Enum.map(list, fn hit -> Enum.uniq(hit)
        |> Enum.map(fn tuple -> Enum.reject(tuple, fn {a, _b} -> a == 0 end)end)end)
        |> Enum.map(fn list -> List.flatten(list)
        |> Enum.group_by(fn {a,_b} -> a             end)
        |> Enum.map(fn {    _a, b} -> Enum.max(b)   end)
        |> Enum.reject(fn { _a, b} -> rem(b,2) == 0 end)end)
        end)
    end

    def construct_hyphens(data) do
        data
        |> Keyword.put_new(:hyphenated, 
           Enum.zip(data[:characters], data[:coordinates]                             )
        |> Enum.map(fn word -> Tuple.to_list(word)end)
        |> Enum.map(fn [word, coords] -> [String.split(word, "", trim: :true), Enum.map(coords, fn {a, _b} -> a end)]end)
        |> Enum.map(fn [word, coords] -> [List.to_tuple(word), coords]      end)
        |> Enum.map(fn [word, coords] -> Hyphen8.Recurse.main(word, coords) end)
        |> Enum.map(fn tuple          -> Tuple.to_list(tuple) end)
        |> Enum.map(fn list           -> Enum.reject(list, fn x -> x == "0" end) end)
        |> Enum.map(fn list           -> Enum.join(list) end)
        |> Enum.join(" "))
        |> Keyword.get(:hyphenated)
    end
end
# in order to fix the issue with short words breaking the parser:
   # any string in the key that ends with a number must not also be the end of the word. All you have to do is recompile the list. you'll need to write  script to do that. but then
   # just add a metacharacter for any word character following the ending number. then "in" won't match