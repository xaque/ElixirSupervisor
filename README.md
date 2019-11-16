## ElixirSupervisor

The application in `app.exs` is a generic skeleton of a business application.

The NameServer is responsible for keeping track of PIDs and process names which enables the Supervisor to kill and restart Info for example without knowing its PID.

### App dependency graph

```
            Database                       CustomerService
           /   |   \
          /    |    \
         /     |     \
        /      |      \
       V       V       V
    Info    Shipper    User <------> Order
```

If any process fails, the supervisor should restart it and all dependencies. E.g. if the Order process exits, User and Order should be restarted. If Database exits, Database, Info, Shipper, User, and Order should all be restarted.

### Supervisor graph

```
                      ___________________________________________________
                      |                 -TopSupervisor-                 |
                      |                  (one_for_one)                  |
                      |                  /           \                  |
                      |                 /            CustomerService    |
                      |_________________________________________________|
         ______________________________
         |    -DatabaseSupervisor-    |
         |       (rest_for_one)       |
         |        /         \         |
         |  Database         \        |
         |____________________________|
                        ____________________________________
                        |  -DatabaseDependencySupervisor-  |
                        |          (one_for_one)           |
                        |      /        |         \        |
                        |   Info     Shipper       \       |
                        |__________________________________|
                                               ________________________
                                               |   -UserSupervisor-   |
                                               |     (one_for_all)    |
                                               |      /       \       |
                                               |   User      Order    |
                                               |______________________|
```

There are 4 supervisors to handle the dependency graph how we want. If any process dies, it will be brought back up (save for the TopSupervisor).

## Testing
You can start the application in `iex` by running the following:

```
c("app.exs")
c("supervisor.exs")
c("nameserver.exs")
{response1,name_server} = NameServer.start_link()
response2 = TopSupervisor.start_link(name_server)
```

Then you can test what happens when you kill a given process using Crasher:

```
Crasher.crash(name_server, :Order)
```

and seeing the dependent process come back up:

```
iex(7)> Crasher.crash(name_server, :Order)
Crashing the module...
true
Elixir.User has started
Elixir.Order has started
```