# EC2

Instance types are

### General Purpose

small and mid-size dbs

### Compute Optimized

high performance, front end fleets, web servers, batch processing, distributed analytics

### Memory Optimized

high performance dbs, distributed memory caches, in memory analytics

### GPU

3D application streaming

### Storage Optimized

NoSQL dbs other dbs

## T2 Burtable Performance Instances

Baseline performance and ability to burst are governed by CPU creds.

Credits are built up and stored for up to 24 hours while instance is operating below baseline performance.

Credits are used to burst above baseline capacity when needed.

If your instance does not maintain a positive CPU Credit balance for bursting condier upgrading to larger instance.

Used when there are huge bursts of demand among a mostly below baseline.

Governed by CPU credits that built up when you are below baseline (like a currency).

You need to maintain a positive CPU balance to get your money's worth.

# EC2 Storage Options

### Elastic Block Store (EBS)
- Replicated Within AZ
- EBS optimized instances provide dedicated throughput between EC2 and EBS volume.
- EBS volumes attached at instance launch are deleted when instance terminated.
- EBS volumes attached to a running instance are not deleted when instance is terminated but are detached with data intact.

Instance Store
- Physically attached to the host server
- Data NOT LOST when OS is rebooted
- Data LOST when
  - underlying drive fails
  - instance is stopped
  - instance is terminated
- do not rely on for valuable, long-term data
- you cannot detach and attach to another instance


