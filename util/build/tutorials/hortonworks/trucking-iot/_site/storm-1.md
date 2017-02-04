# Storm - Architecture

## Outline
-   Storm Architecture (under the hood)


## Storm Architecture (under the hood)

-   **Nimbus node**: Runs a daemon, called _Nimbus_, that is responsible for assigning tasks to worker nodes, monitoring for failures and distributing topology code around the cluster.
-   **Worker node**: Runs a daemon, called _Supervisor_, that listens for instructions given to it by _Nimbus_.  Upon instruction, it starts/stops worker _processes_.
-   **Worker process**: Runs on a worker worker node and is responsible for executing the actual code of a Storm topology (remember: a _topology_ is just the overall network of tasks to perform).
-   **Zookeeper**: /
-   **Task**:
-   **Executor (thread)**:
