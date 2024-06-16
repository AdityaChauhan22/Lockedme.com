import java.io.File;
import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Paths;
import java.util.Arrays;
import java.util.Comparator;
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
                case 2:
                    addFile();
                    break;
                case 3:
                    deleteFile();
                    break;
                case 4:
                    searchFile();
                    break;
                case 5:
                    listFilesByLastModified();
                    break;
                case 6:
                    displayFileSize();
                    break;
                case 7:
                    countFilesAndDirectories();
                    break;
                case 8:
                    readFileContent();
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
   
    private static void addFile() {
        System.out.print("Enter file name to add: ");
        String fileName = scanner.nextLine();
        try {
            File file = new File(fileName);
            if (file.createNewFile()) {
                System.out.println("File created: " + fileName);
            } else {
                System.out.println("File already exists.");
            }
        } catch (IOException e) {
            System.out.println("An error occurred while creating the file.");
            e.printStackTrace();
        }
    }

    private static void deleteFile() {
        System.out.print("Enter file name to delete: ");
        String fileName = scanner.nextLine();
        File file = new File(fileName);
        if (file.delete()) {
            System.out.println("File deleted: " + fileName);
        } else {
            System.out.println("Failed to delete the file.");
        }
    }

    private static void searchFile() {
        System.out.print("Enter file name to search: ");
        String fileName = scanner.nextLine();
        File file = new File(fileName);
        if (file.exists()) {
            System.out.println("File found: " + fileName);
        } else {
            System.out.println("File not found.");
        }
    }

    private static void listFilesByLastModified() {
        File directory = new File(".");
        File[] files = directory.listFiles();
        if (files != null) {
            Arrays.sort(files, Comparator.comparingLong(File::lastModified));
            for (File file : files) {
                System.out.println(file.getName() + " (Last modified: " + file.lastModified() + ")");
            }
        } else {
            System.out.println("No files found.");
        }
    }

    private static void displayFileSize() {
        System.out.print("Enter file name to display size: ");
        String fileName = scanner.nextLine();
        File file = new File(fileName);
        if (file.exists()) {
            System.out.println("File size: " + file.length() + " bytes");
        } else {
            System.out.println("File not found.");
        }
    }

    private static void countFilesAndDirectories() {
        File directory = new File(".");
        File[] files = directory.listFiles();
        if (files != null) {
            int fileCount = 0;
            int dirCount = 0;
            for (File file : files) {
                if (file.isFile()) {
                    fileCount++;
                } else if (file.isDirectory()) {
                    dirCount++;
                }
            }
            System.out.println("Total files: " + fileCount);
            System.out.println("Total directories: " + dirCount);
        } else {
            System.out.println("No files or directories found.");
        }
    }

    private static void readFileContent() {
        System.out.print("Enter file name to read content: ");
        String fileName = scanner.nextLine();
        try {
            String content = new String(Files.readAllBytes(Paths.get(fileName)));
            System.out.println("File content:\n" + content);
        } catch (IOException e) {
            System.out.println("An error occurred while reading the file.");
            e.printStackTrace();
        }
    }
}
