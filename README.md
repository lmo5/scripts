# File Structure Creation Script

This Python script allows you to create a nested file and folder structure based on an input text file. It provides a preview of the structure before creation and only creates files and folders that don't already exist.

## Requirements

- Python 3.6 or later

## Installation

1. Clone this repository or download the `create_structure.py` script.
2. Ensure you have Python 3.6 or later installed on your system.

## Usage

1. Prepare an input file (e.g., `structure.md`) that describes your desired file structure. Use indentation or tree characters to indicate nesting.

2. Run the script from the command line:

   ```
   python create_structure.py <path_to_your_structure_file>
   ```

   Replace `<path_to_your_structure_file>` with the path to your input file.

3. The script will display a preview of the structure it's going to create.

4. You will be prompted to confirm if you want to create the structure. Type 'y' to proceed or 'n' to cancel.

5. If you confirm, the script will create the structure, skipping any files or folders that already exist.

## Input File Format

- Use indentation or tree characters (│, ├, └, ─) to indicate the nesting level of files and folders.
- End folder names with a forward slash (/).
- File names should not end with a forward slash.

Example input file (`structure.md`):

```
project/
  src/
    main.py
    utils/
      helpers.py
  docs/
    README.md
  tests/
    test_main.py
```

## Example

1. Save the above example as `structure.md`.
2. Run the script:

   ```
   python create_structure.py structure.md
   ```

3. You'll see a preview of the structure:

   ```
   Tree structure preview:
   └── project
       ├── src
       │   ├── main.py
       │   └── utils
       │       └── helpers.py
       ├── docs
       │   └── README.md
       └── tests
           └── test_main.py

   Do you want to create this structure? (y/n)
   ```

4. Type 'y' and press Enter to create the structure.

5. The script will create the files and folders, showing output like this:

   ```
   Created directory: project
   Created directory: project/src
   Created file: project/src/main.py
   Created directory: project/src/utils
   Created file: project/src/utils/helpers.py
   Created directory: project/docs
   Created file: project/docs/README.md
   Created directory: project/tests
   Created file: project/tests/test_main.py
   Structure creation process completed.
   ```

## Notes

- The script will not overwrite existing files or folders.
- If a file or folder already exists, the script will skip it and display a message.
- Make sure you have the necessary permissions to create files and folders in the target directory.

## Troubleshooting

If you encounter any issues:
- Ensure you're using Python 3.6 or later.
- Check that your input file is formatted correctly.
- Verify that you have write permissions in the directory where you're running the script.

For any other problems or questions, please open an issue in the GitHub repository.