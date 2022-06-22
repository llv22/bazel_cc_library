import org.apache.velocity.Template;
import org.apache.velocity.VelocityContext;
import org.apache.velocity.app.VelocityEngine;

import java.awt.*;
import java.awt.datatransfer.Clipboard;
import java.awt.datatransfer.StringSelection;
import java.io.*;

public class TickGenerator {
    public static void main(String[] args) throws IOException {
        VelocityEngine velocityEngine = new VelocityEngine();
        velocityEngine.init();

        String src = "srcs = [\"hello-tick.cc\"";
        String header = "hdrs = [\"hello-tick.h\"";
        for (int i= 1; i <= 6000; i++) {
            generate(velocityEngine, "hello-tick.cc.vm", "hello-tick%s.cc", Integer.toString(i));
            src += String.format(",%s", String.format("\"hello-tick%s.cc\"", Integer.toString(i)));
            generate(velocityEngine, "hello-tick.h.vm", "hello-tick%s.h", Integer.toString(i));
            header += String.format(",%s", String.format("\"hello-tick%s.h\"", Integer.toString(i)));
        }
        src += "],\n";
        header += "],\n";
        StringSelection stringSelection = new StringSelection(src + header);
        Clipboard clipboard = Toolkit.getDefaultToolkit().getSystemClipboard();
        clipboard.setContents(stringSelection, null);
    }

    private static void generate(VelocityEngine velocityEngine, String templateFile, String outFileNameTemplate, String index) throws IOException {
        Template cc = velocityEngine.getTemplate(templateFile);
        VelocityContext context = new VelocityContext();
        context.put("number", index);
        try(Writer writer = new FileWriter(String.format(outFileNameTemplate, index))) {
            cc.merge(context, writer);
        }
    }
}
