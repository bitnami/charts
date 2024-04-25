conf = new File('conf/remote.yaml');
cluster = Cluster.build(conf).create();
client = cluster.connect();

// Add a vertex
client.submit("graph.addVertex('name', '${args[0]}')").all().get();
// Read all vertex
r = client.submit('g.V().values("name")');
println "Result:" + r.toList();
