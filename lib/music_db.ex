defmodule MusicDB do
  alias MusicDB.{Album, Artist, Repo, Track}

  def test() do
    %Artist{
      name: "Miles Davis",
      albums: [
        %Album{
          title: "Kind Of Blue",
          tracks: [
            %Track{
              title: "So What",
              duration: 544,
              index: 1
            },
            %Track{
              title: "Freddie Freeloader",
              duration: 574,
              index: 2
            },
            %Track{
              title: "Blue In Green",
              duration: 327,
              index: 3
            },
            %Track{
              title: "All Blues",
              duration: 693,
              index: 4
            },
            %Track{
              title: "Flamenco Sketches",
              duration: 481,
              index: 5
            }
          ]
        }
      ]
    }
    |> Repo.insert()
  end
end
