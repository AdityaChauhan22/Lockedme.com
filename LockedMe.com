

import java.io.File;
import java.util.Arrays;
import java.util.Scanner;

public class Project {
    private static Scanner scanner = new Scanner(System.in);

    public static void main(String[] args) {
        while (true) {
            System.out.println("\nFile Management System");
            System.out.println("1. Retrieve file names (ascending order)");
            System.out.println("2. Add a file");
            System.out.println("3. Delete a file");
            System.out.println("4. Search for a file");
            System.out.println("5. List files sorted by last modified date");
            System.out.println("6. Display file size");
            System.out.println("7. Count files and directories");
            System.out.println("8. Read file content");
            System.out.println("9. Exit");
            System.out.print("Choose an option: ");
            int choice = scanner.nextInt();
            scanner.nextLine(); // consume newline
            
            
            switch (choice) {
                case 1:
                    retrieveFileNames();
                    break;
               
                case 9:
                    System.out.println("Exiting application.");
                    return;
                default:
                    System.out.println("Invalid option. Please try again.");
            }
        
        }
    }
    private static void retrieveFileNames() {
        File directory = new File(".");
        File[] files = directory.listFiles();
        if (files != null) {
            Arrays.sort(files);
            for (File file : files) {
                System.out.println(file.getName());
            }
        } else {
            System.out.println("No files found.");
        }
    }
}
   
    
