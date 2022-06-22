import org.apache.velocity.Template;
import org.apache.velocity.VelocityContext;
import org.apache.velocity.app.VelocityEngine;

import java.io.FileWriter;
import java.io.IOException;
import java.io.Writer;
import java.util.stream.Collectors;
import java.util.stream.IntStream;

public class BuildGenerator {
    public static void main(String[] args) throws IOException {
        VelocityEngine velocityEngine = new VelocityEngine();
        velocityEngine.init();
        Template cc = velocityEngine.getTemplate("BUILD.vm");
        VelocityContext context = new VelocityContext();
        context.put("ns1", IntStream.range(1, 1501).boxed().collect(Collectors.toList()));
        context.put("ns2", IntStream.range(1501, 3001).boxed().collect(Collectors.toList()));
        context.put("ns3", IntStream.range(3001, 4501).boxed().collect(Collectors.toList()));
        try(Writer writer = new FileWriter("BUILD")) {
            cc.merge(context, writer);
        }
    }

}
