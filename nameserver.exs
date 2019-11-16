defmodule NameServer do
  use GenServer

  # Start Helper Functions (Don't Modify)
  def start_link() do
    GenServer.start_link(__MODULE__, [], [])
  end

  def start() do
    GenServer.start(__MODULE__, [],  [])
  end

  def register(name_server, name) do
    GenServer.call(name_server, {:register, name})
  end

  def register(name_server, name, pid) do
    GenServer.cast(name_server, {:register, name, pid})
  end

  def resolve(name_server, name) do
    GenServer.call(name_server, {:resolve, name})
  end
  #End Helper Functions

  # Initialize name/pid map
  def init(_) do
    {:ok, %{}}
  end

  # Register name with pid from calling process
  def handle_call({:register, name}, {pid, _from}, state) do
    {:reply, :ok, Map.put(state, name, pid)}
  end

  # Resolve pid from name
  def handle_call({:resolve, name}, _from, state) do
    pid = if state[name] do
            state[name]
          else
            :error
          end
    {:reply, pid, state }
  end

  # Register name with given pid asynchronously
  def handle_cast({:register, name, pid}, state) do
    {:noreply, Map.put(state, name, pid)}
  end
  

  def handle_call(request, from, state) do
    super(request, from, state)
  end

  def handle_cast(request, state) do
    super(request, state)
  end

  def hande_info(_msg, state) do
    {:noreply, state}
  end
end