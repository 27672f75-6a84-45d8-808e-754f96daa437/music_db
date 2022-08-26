alias MusicDB.Repo

# aggregate 함수를 통해 데이터베이스에서 값을 가져올수있다.
Repo.aggregate("albums", :count, :id) #=> 5

# 옵션의 종류로는 count, avg, min, max, sum 등이 있다.
