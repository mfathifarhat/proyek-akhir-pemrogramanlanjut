import org.jpl7.JPL;
import org.jpl7.Query;
import org.jpl7.Term;
import java.util.Arrays;
import java.util.Map;

public class TestJPL {
    public static void main(String[] args) {
        // 1. Configure SWI-Prolog engine startup arguments
        // "swipl"        -> executable placeholder (argv[0])
        // "-q"           -> quiet mode (suppresses welcome banner)
        // "--no-signals" -> prevents SWI-Prolog from overriding JVM OS signal handlers
        String[] initArgs = {
            "swipl",
            "-q",
            "--no-signals"
        };

        // 2. Apply arguments and explicitly boot the Prolog engine
        JPL.setDefaultInitArgs(initArgs);
        if (!JPL.init()) {
            throw new IllegalStateException("Failed to initialize the SWI-Prolog JPL engine.");
        }

        // 3. Confirm active engine flags
        System.out.println("JPL Initialized! Active args: " + Arrays.toString(JPL.getActualInitArgs()));

        // 4. Verify bidirectional communication with a built-in Prolog query
        Query versionQuery = new Query("current_prolog_flag(version_data, V)");
        if (versionQuery.hasSolution()) {
            Map<String, Term> solution = versionQuery.oneSolution();
            System.out.println("Connected to: " + solution.get("V"));
        }
        versionQuery.close();
    }
}