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

  # JOIN 시리즈

  # join에서 join 조건인 on이 주어지지 않는다면 그건 cross join이다.
  # :join 키워드는 기본적으로 inner_join을 수행한다.
  def join_artist_album_title() do
    from(artist in Artist, [
      {:join, album in Album},
      {:on, artist.id == album.artist_id},
      {:select, {artist.name, album.title}}
    ])
    |> Repo.all()
  end

  # 먼저 주어진 테이블 A 기준으로 테이블 B를 조인함.
  # 합쳐진 왼쪽 테이블에 nil이 나오지 않는 데이터는 모두 반환함.
  # 해당 결과에서 B가 nil인것을 모두 제거하면 LEFT JOIN 제거하지 않으면 LEFT OUTER JOIN이 된다.
  def left_outer_join_artist_album_title() do
    from(artist in Artist, [
      {:left_join, album in Album},
      {:on, artist.id == album.artist_id},
      {:select, {artist.name, album.title}}
    ])
    |> Repo.all()
  end

  def left_join_artist_album_title() do
    from(artist in Artist, [
      {:left_join, album in Album},
      {:on, artist.id == album.artist_id},
      {:where, false == is_nil(album.artist_id)},
      {:select, {artist.name, album.title}}
    ])
    |> Repo.all()
  end

  # 앨범에서 아티스트의 아이디가 없는 앨범을

  # 이후에 주어진 테이블 B 기준으로 테이블 A를 조인함.
  # 합쳐진 오른쪽 테이블에 nil이 나오지 않는 데이터는 모두 반환함.
  # 해당 결과에서 A가 nil인것을 모두 제거하면 RIGHT JOIN 제거하지 않으면 RIGHT OUTER JOIN이 된다.
  def right_join_artist_album_title() do
    from(artist in Artist, [
      {:right_join, album in Album},
      {:on, artist.id == album.artist_id},
      {:select, {artist.name, album.title}}
    ])
    |> Repo.all()
  end

  # 주어진 테이블을 조건 없이 모두 매칭한다.
  # cartesian product라고 SQL에 키워드로 존재하였으나, 프로덕트가 SQL이 표준화 진행되면서
  # ANSI 표준으로 바뀌었는데 그 이름이 CROSS JOIN이 되었다.
  # 모든 경우를 고려하기 때문에 조인조건을 적을수없다.
  def cross_join_artist_album_title() do
    from(artist in Artist, [
      {:cross_join, album in Album},
      {:select, {artist.name, album.title}}
    ])
    |> Repo.all()
  end

  # 테이블을 합치고 nil이 있는 결과에 상관없이 모두 반환함.
  def full_join_artist_album_title do
    from(artist in Artist, [
      {:full_join, album in Album},
      {:on, artist.id == album.artist_id},
      {:select, {artist.name, album.title}}
    ])
    |> Repo.all()
  end

  # 가장 긴 곡 가져오기
  # last를 사용하면 쿼리의 수행의 가장 마지막 결과물을 가져올수있다.
  def get_longest_track() do
    from(track in Track, [
      {:select, track}
    ])
    |> last(:duration)
  end

  # limit로 쿼리 결과 제한하기
  def all_trakcs_by_limit(limit_number) do
    from(artist in Artist, [
      {:join, album in Album},
      {:on, artist.id == album.artist_id},
      {:join, track in Track},
      {:on, album.id == track.album_id},
      {:limit, ^limit_number},
      {:select, {artist.name, album.title, track.title}}
    ])
    |> Repo.all()
  end

  # offset로 쿼리 결과에서 offset만큼 쿼리 결과를 지운다.
  def all_trakcs_by_offset(offset_number) do
    from(artist in Artist, [
      {:join, album in Album},
      {:on, artist.id == album.artist_id},
      {:join, track in Track},
      {:on, album.id == track.album_id},
      {:offset, ^offset_number},
      {:select, {artist.name, album.title, track.title}}
    ])
    |> Repo.all()
  end

  def sorted_track_preload_album() do
    track_query =
      from(track in Track, [
        {:order_by, track.duration}
      ])

    from(album in Album, [
      {:preload, [tracks: ^track_query]}
    ])
    |> Repo.all()
  end

  # 앨범을 모두 가져오고 앨범에서 곡 길이가 duration 이상인 곡을 포함
  def get_over_duration_track_preload_album(duration) do
    over_duration_track_query =
      from(track in Track, [
        {:where, track.duration > ^duration}
      ])

    from(album in Album, [
      {:preload, [tracks: ^over_duration_track_query]}
    ])
    |> Repo.all()
  end

  # reverse_order를 사용하여 쿼리 순서를 반대로 할 수 있다.
  def get_longest_track_list() do
    ordered_track_query =
      from(track in Track, [
        {:order_by, track.duration}
      ])

    from(track in reverse_order(ordered_track_query), [
      {:select, {track.title, track.duration}}
    ])
    |> Repo.all()
  end

  # 가장 긴 10곡의 평균값을 구하는 쿼리
  # subquery를 사용하여 구현
  def get_top_10_of_duration_track() do
    top_10_duration_track_query =
      from(track in Track, [
        {:order_by, [desc: :duration]},
        {:limit, 10}
      ])

    from(track in subquery(top_10_duration_track_query), [
      {:select, avg(track.duration)}
    ])
    |> Repo.all()
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
