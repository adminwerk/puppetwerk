# [SERVER]

stage {"one-after-main": require => Stage['main']}
stage {"two-after-main": require => Stage['one-after-main']}
stage {"three-after-main": require => Stage['two-after-main']}
stage {"four-after-main": require => Stage['three-after-main']}
stage {"five-after-main": require => Stage['four-after-main']}
stage {"six-after-main": require => Stage['five-after-main']}

node 'server.example.com' {
  

  include class1,
          class2,
  			  class3,
  			  class4

  class {"class1::setup": stage => 'one-after-main' }
  class {"class1::conf": stage => 'two-after-main' }
  class {"class1::populate": stage => 'three-after-main' }
  class {"class1::ndb_mgmd": stage => 'four-after-main' }
  class {"class1::ndb": stage => 'five-after-main' }
  class {"class1::mysqld": stage => 'six-after-main' }


}