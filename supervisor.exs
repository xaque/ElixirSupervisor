defmodule TopSupervisor do
  use Supervisor
 
  def start_link(ns) do
    Supervisor.start_link(__MODULE__, ns )
  end
 
  def init(ns) do
    children = [
      worker(CustomerService, [ns]),
      worker(DBSupervisor, [ns])
    ]
    supervise(children, strategy: :one_for_one)
  end
end

defmodule DBSupervisor do
  use Supervisor
 
  def start_link(ns) do
    Supervisor.start_link(__MODULE__, ns )
  end
 
  def init(ns) do
    children = [
      worker(Database, [ns]),
      worker(DatabaseDependentSupervisor, [ns]),
    ]
    supervise(children, strategy: :rest_for_one)
  end
end

defmodule DatabaseDependentSupervisor do
  use Supervisor
 
  def start_link(ns) do
    Supervisor.start_link(__MODULE__, ns )
  end
 
  def init(ns) do
    children = [
      worker(Info, [ns]),
      worker(Shipper, [ns]),
      worker(UserSupervisor, [ns])
    ]
    supervise(children, strategy: :one_for_one)
  end
end

defmodule UserSupervisor do
  use Supervisor
 
  def start_link(ns) do
    Supervisor.start_link(__MODULE__, ns )
  end
 
  def init(ns) do
    children = [
      worker(User, [ns]),
      worker(Order, [ns])
    ]
    supervise(children, strategy: :one_for_all)
  end
end