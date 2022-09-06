# 외부에 어떤 다른 Application
defmodule SearchEngine do
  # MusicDB와 동기화 되는 데이터가 들어간다.
  def update!(item) do
    # search engine logic happens here...
    {:ok, item}
  end

  def update(item) do
    # search engine logic happens here...
    {:ok, item}
  end

  def update(_repo, changes, extra_argument) do
    # search engine logic happens here...
    {:ok, {changes, extra_argument}}
  end
end
