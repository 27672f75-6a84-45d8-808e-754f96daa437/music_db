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

  def test2() do
    %Artist{
      name: "Bill Evans",
      albums: [
        %Album{
          title: "You Must Believe In Spring",
          tracks: [
            %Track{
              title: "B Minor Waltz (for Ellaine)",
              duration: 192,
              index: 1
            },
            %Track{
              title: "You Must Believe In Spring",
              duration: 337,
              index: 2
            },
            %Track{
              title: "Gary's Theme",
              duration: 255,
              index: 3
            },
            %Track{
              title: "We Will Meet Again (for Harry)",
              duration: 239,
              index: 4
            },
            %Track{
              title: "The Peacocks",
              duration: 360,
              index: 5
            },
            %Track{
              title: "Sometime Ago",
              duration: 292,
              index: 6
            },
            %Track{
              title: "Theme From M*A*S*H (Suicide Is Painless)",
              duration: 353,
              index: 7
            },
            %Track{
              title: "Without a Song",
              duration: 485,
              index: 8
            },
            %Track{
              title: "Freddie Freeloader",
              duration: 454,
              index: 9
            },
            %Track{
              title: "All of You",
              duration: 489,
              index: 10
            }
          ]
        },
        %Album{
          title: "Portrait In Jazz",
          tracks: [
            %Track{
              title: "Come Rain Or Come Shine",
              duration: 204,
              index: 1
            },
            %Track{
              title: "Autumn Leaves",
              duration: 360,
              index: 2
            },
            %Track{
              title: "Witchcraft",
              duration: 277,
              index: 3
            },
            %Track{
              title: "When I Fall In Love",
              duration: 297,
              index: 4
            },
            %Track{
              title: "Peri's Scope",
              duration: 195,
              index: 5
            },
            %Track{
              title: "What Is This Thing Called Love?",
              duration: 276,
              index: 6
            },
            %Track{
              title: "Spring Is Here",
              duration: 309,
              index: 7
            },
            %Track{
              title: "Someday My Prince Will Come",
              duration: 297,
              index: 8
            },
            %Track{
              title: "Blue In Green",
              duration: 325,
              index: 9
            }
          ]
        }
      ]
    }
    |> Repo.insert()
  end
end
