# Schedule

## 排班流程
- 先算出每個月的總點數
- 由資歷低的先算7, 6, 5, 4 點, 
- 如果超過，再從資深的開始減點,最低3點 
- 點數分配完後開始排班
- 每個人預不要什麼班就不要排
- 一個一個人去排入
- 不要有出現QOD的情況
- 假日最多兩班
- 星期五輪流上
- 如果點數不平均，則這個月記錄下來超過的點數，下個月再減回來

## 月分
建立每個月的月份map
- 計算每個月的總點數
- 星期五
- 星期六、日
- 國定假日
- 今天是什麼人值班
- 今天有幾點

## 醫師
### 住院醫師
- 每個人的點數統計
- 每個人會預班
- 不要禮拜幾


## 主治醫師
  - 計算點數(人工)
  - 指定的日期先排
  - 先排假日班
  - 想要的星期幾先排
  - 指定想排的特定天數
  - 不可以排不想要的班
  - 急診班排法；先排值班，值班的隔天不要排急診班
  - 每個月的點數，一般來說是兩點，從年資高的開始減

進階：
門診避開(用星期幾), done
cover 班的功能


  """
  - first, setting up the month, done
  - setting up all the doctors(a string or a list, pipe into the map with id), done
  - setting the points for everyone, done
  - start calculating from the day1
    - holidays first for all people, done
    - if all holidays shared by all people then it is done;
      if there is an extra one//pick from r1/r2
    - calculate all the rest day
  - if hit an error, restart again; if restart 100 times, show it was wrong
  - if it all success, show success, and the result
  """

## elixir
agent, genserver to store state

## todo
- add phoenix?
- add ecto with sqlite to save data
- export maps to json?
- use json to excel converter
- add typespec to check/using dialyxir 
- write test, use ExUnit
