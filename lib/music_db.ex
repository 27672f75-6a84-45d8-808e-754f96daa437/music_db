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
  def artist_album_as_binding() do
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
  def artist_album_as_mix_binding() do
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
  def artist_album_parent_as_binding() do
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

  # distinct를 사용해서 track의 index가 중복된 결과를 제거하여 반환함
  def distinct_track_by_index() do
    from(track in Track, [
      {:distinct, track.index},
      {:order_by, track.index},
      {:select, track.title}
    ])
    |> Repo.all()
  end

  # dynamic을 사용한 동적 쿼리 생성
  def album_by_name_using_dynamic(album_name) do
    dynamic_query = dynamic([album], album.title == ^album_name)

    from(Album, where: ^dynamic_query) |> Repo.all()
  end

  # 앨범 제목이면서 트랙의 제목이 아닌것을 가져옴.
  def except_same_album_track_title() do
    tracks_query =
      from(track in Track, [
        {:select, track.title}
      ])

    from(album in Album, [
      {:select, album.title},
      {:except, ^tracks_query}
    ])
    |> Repo.all()
  end

  # where절이 적용되기전으로 리셋한 결과가 나온다.
  # join을 리셋하고 싶을때 단, join을 하여 나온 바인딩 결과를 사용하는 절이 있으면 제거 불가능하다.
  def exclude_join_artist() do
    artist_album_join_query =
      from(artist in Artist, [
        {:join, album in Album},
        {:on, artist.id == album.artist_id},
        {:join, track in Track},
        {:on, track.album_id == album.id},
        {:where, track.duration > 500},
        {:order_by, track.title},
        {:select, track.title}
      ])

    exclude(artist_album_join_query, :where)
    |> Repo.all()
  end

  # 가장 짧은 곡 가져오기
  def get_shortest_track() do
    from(track in Track, [
      {:select, track}
    ])
    |> first(:duration)
  end

  def get_track_count_in_album() do
    from(track in Track, [
      {:group_by, [track.album_id]},
      {:select, {track.album_id, count()}}
    ])
    |> Repo.all()
  end

  # has_named_binding? 함수를 통해 이미 이름이 쿼리내에서 바인딩 되었나 확인할수있다.
  def has_named_binding_in_album_query?() do
    from(artist in Artist, [
      {:join, album in Album},
      {:as, :album},
      {:on, artist.id == album.artist_id}
    ])
    |> has_named_binding?(:album)
  end

  # 곡이 5개이상 수락된 앨범의 ID를 가져오는 쿼리
  # having은 그룹화된 쿼리에 where과 같은 기능을한다.
  def get_has_track_more_than_5_album() do
    from(track in Track, [
      {:group_by, [track.album_id]},
      {:having, count() > 5},
      {:select, {track.album_id, count()}}
    ])
    |> Repo.all()
  end

  # 앨범 제목이면서도 트랙의 제목인것을 가져옴.
  # intersect를 사용하면 교집합을 가져옴
  def get_intersect_albums_and_tracks_title() do
    tracks_query = from(track in Track, [{:select, track.title}])
    from(album in Album, [{:select, album.title}, {:intersect, ^tracks_query}])
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
