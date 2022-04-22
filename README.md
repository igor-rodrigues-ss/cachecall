# Cachecall

## Description
A library for cache data in Python with TTL, cache groups and date to expire cached data.

## Features
- Algorithm (FIFO)
- TTL
- Expire Time
- Cache groups
- Control for clear cache
- Examples

### Algorithm
The FIFO Algorithm is used to control the input and output of data for cache groups.

### Cache groups
By default each function has its own cache group to keep cached data separated.

### Examples

##### Quick example

```python
from cachecall import cache

@cache()
def func(x=None):
    print("call")
    return 10
```

##### Cache async functions
```python
from cachecall import cache

@cache()
async def afunc(x=None):
    print("call")
    return 15

await afunc()
```

##### Max Size
```python
from cachecall import cache

@cache(max_size=2)
def func(x):
    print("call")
    return x

func("a") # Add value "a" in cache
func("b") # Add value "b" in cache
func("c") # Remove value "a" from cache and Add value "c"
func("d") # Remove value "b" from cache and Add value "d"
```

##### TTL (Time To Live)

```python
from cachecall import cache

@cache(ttl=10)
def func(x=1):
    print("call")
    return "abc"
```

- Each 10 seconds the cache for the function ```func``` will be expired.

##### Expire Time

```python
from cachecall import cache, ExpireTime

@cache(expire_time=ExpireTime(10, 15, 20))
def func(a=None):
    print("call")
    return "xyz"
```

- Every day at 10:15:20 the value cached will expire.
- If the ```ExpireTime(10, 15, 20)``` will defined before 10:15:20 in current day, the the data cached will expired in same day, but if ExpireTime will defined after the 10:15:20, the cached value will be expired in next day.


##### TTL with Expire Time

```python
from cachecall import cache, ExpireTime

@cache(ttl=18000, expire_time=ExpireTime(6, 0, 0))
def func(a=None):
    print("call")
    return "xyz"
```
- ```ttl``` and ```expire_time``` can be used together. In this example the cached data will expire each 5 hours and every day at 6:00:00.

##### Cache group
```python
from cachecall import cache

@cache(group_name='some_group_name')
def do_a(x=None):
    print("call a")
    return "xyz"

@cache(group_name='some_group_name')
def do_b(x=None):
    print("call abc")
    return "abc"
```

- All the cached data will be stored inside a cache group called "some_group_name".
- Even though you use many different functions with the same parameters inside the same cache group, all cached data are associated with your specific function.

##### clear cache group

```python
from cachecall import cache, clear_cache

@cache(group_name='some_group_name')
def func(x=None):
    print("call")
    return "xyz"

clear_cache('some_group_name') # Clear all cached data inside some_group_name
```

### cache decorator

```python
from cachecall import cache
```

#### Parameters
- max_size: *Optional[int]*
    - Number of values (or call to cached function) that will be stored in cache.
    - If None the cache size will be unlimited.
    - Default value is None.

- group_name: *Optional[str]*
    - Group name for cached data.
    - Each function has their own cache group, but if you wish to use the same cached data for different functions just use the same *group_name* for these functions. 
    - If None the group name default will be "function-name_uuid4".
    - Default value is None.

- ttl: *Optional[Union[int, float]]*
    - (Time To Live) Value in seconds to expire the cached data.
    - If None the value never expires.
    - Default value is None.

- expire_time: *Optional[ExpireTime]*
    - Specific time to expire a cached value daily.
    - If None the value never expires.
    - Default value is None.

- ignore_keys: *Optional[Tuple[str]]*
    - Tuple of kwargs names that will be ignored in cache. 
    - If some cached data exists and the value of some ignored_key is changed, the data will be continued cached because all kwargs arguments mapped in ignore_keys tuple will be ignored.
 

#### Expire Time
```python
from cachecall import ExpireTime

@dataclass
class ExpireTime:
    hour: int
    minute: int
    second: int
```