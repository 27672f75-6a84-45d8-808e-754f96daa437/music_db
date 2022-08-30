defmodule MusicDB do
  alias MusicDB.{Album, Artist, Repo, Track}
  import Ecto.Query

  def get_track_over_duration(duration) do
    Repo.all(
      from(track in Track, [
        {:where, track.duration > ^duration},
        {:group_by, track.title},
        {:select, {track.title, count()}}
      ])
    )
  end

  # 바인딩이 여러번 있었을때 ...을 사용하여 바인딩 생략하기
  # 순서가 있는 바인딩을 사용할때는 아래와 같이 작성하면된다.
  def artist_album_track_binding() do
    artist_join_album =
      from(artist in Artist, [
        {:join, album in Album},
        {:on, artist.id == album.artist_id}
      ])

    artist_join_album_join_track =
      from([artist, album] in artist_join_album, [
        {:join, track in Track},
        {:on, album.id == track.album_id}
      ])

    # 쿼리의 마지막 바인딩에만 관심이 있을경우 ...을 사용하여 이전의 모든 바인딩을 지정 가능하다.
    from([artist, ..., track] in artist_join_album_join_track, [
      {:select, {artist.name, track.title}}
    ])
    |> Repo.all()
  end

  # 명시적 바인딩을 하려면 as 키워드를 추가한다.
  def artist_album_as_binding do
    artist_join_album =
      from(artist in Artist, [
        {:as, :artist},
        {:join, album in Album},
        {:as, :album},
        {:on, artist.id == album.artist_id}
      ])

    from([album: album, artist: artist] in artist_join_album, [
      {:select, {album.title, artist.name}}
    ])
    |> Repo.all()
  end

  # 명시적 바인딩은 항상 바인딩 목록의 끝에 위치해야한다.
  def artist_album_as_mix_binding do
    artist_join_album =
      from(artist in Artist, [
        {:join, album in Album},
        {:as, :album},
        {:on, artist.id == album.artist_id}
      ])

    from([artist, album: album] in artist_join_album, [
      {:select, {album.title, artist.name}}
    ])
    |> Repo.all()
  end

  # 아직 정의하지 않은 상위 바인딩을 참조해야할때 parent_as 바인딩
  def artist_album_parent_as_binding do
    child_query =
      from(
        album in Album,
        [
          {:where, parent_as(:artist).id == album.artist_id}
        ]
      )

    from(artist in Artist, [
      {:as, :artist},
      {:inner_lateral_join, album in subquery(child_query)},
      {:select, {artist.name, album.title}}
    ])
    |> Repo.all()
  end

  # 가장 짧은 곡 가져오기
  def get_shortest_track() do
    from(track in Track, [
      {:select, track}
    ])
    |> first(:duration)
  end

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
