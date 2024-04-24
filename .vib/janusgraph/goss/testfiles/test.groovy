import org.apache.tinkerpop.gremlin.structure.io.binary.TypeSerializerRegistry

TypeSerializerRegistry typeSerializerRegistry = TypeSerializerRegistry.build().addRegistry(JanusGraphIoRegistry.instance()).create();

cluster = Cluster.build().addContactPoint(args[0]).port(args[1].toInteger()).serializer(new GraphBinaryMessageSerializerV1(typeSerializerRegistry)).create()
client = cluster.connect()

client.submit("graph.addVertex('name', '${args[2]}')")
r = client.submit('g.V().values("name")')
println "Result:" + r.toList()
