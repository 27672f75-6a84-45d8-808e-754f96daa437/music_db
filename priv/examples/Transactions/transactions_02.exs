
# 첫번째 insert시 명령이 실패해야하지만 성공해버렸다.
# 이유는 insert를 사용해서이다.

cs =
  %Artist(name: nil)
  |> Ecto.Changeset.change()
  |> Ecto.Changeset.validate_required([:name])
Repo.transaction(fn ->
  case Repo.insert(cs) do
    {:ok, _artist} -> IO.puts("Artist insert succeeded")
    {:error, _value} -> IO.puts("Artist insert failed")
  end
  case Repo.insert(Log.changeset_for_insert(cs)) do
    {:ok, _log} -> IO.puts("Log insert succeeded")
    {:error, _value} -> IO.puts("Log insert failed")
  end
end)

# => Artist insert failed
# => Log insert succeeded
# => {:ok :ok}


# insert를 사용해서 Elixir오류를 발생시키지 않아도된다.
# Repo.rollback을 사용해서 실패시에 중간에 실행을 멈추고 롤백하기 떄문
cs = Ecto.Changeset.change(%Artist{name: nil})
  |> Ecto.Changeset.validate_required([:name])
    Repo.transaction(fn ->
      case Repo.insert(cs) do
        {:ok, _artist} -> IO.puts("Artist insert succeeded")
        {:error, _value} -> Repo.rollback("Artist insert failed")
      end
      case Repo.insert(Log.changeset_for_insert(cs)) do
        {:ok, _log} -> IO.puts("Log insert succeeded")
        {:error, _value} -> Repo.rollback("Log insert failed")
      end
end)
# => {:error, "Artist insert failed"}
