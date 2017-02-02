## HDFS Snapshots Concepts

HDFS Snapshots are read-only point-in-time copies of the file system. Snapshots can be taken on a subtree of the file system or the entire file system and are:

- Performant and Reliable: Snapshot creation is atomic and instantaneous, no matter the size or depth of the directory subtree
- Scalable: Snapshots do not create extra copies of blocks on the file system. Snapshots are highly optimized in memory and stored along with the NameNode’s file system namespace
