# Active Directory Automation Scripts

This repository contains a collection of PowerShell scripts designed to automate basic Active Directory lab setups. These scripts are intended to help users quickly create and configure a test environment for learning and experimentation.

## Scripts

### `user_gen.ps1`

This script creates multiple Active Directory users with randomized attributes. It generates usernames, passwords, and other user details, and logs the process.

#### Features

-   Generates realistic usernames based on a list of first and last names.
-   Creates random passwords that meet complexity requirements.
-   Assigns users to random departments and offices.
-   Logs all actions to a file for auditing.
-   Handles errors gracefully and provides detailed error messages.
-   Automatically installs RSAT tools if they are not already installed.

#### Usage

1.  Run the script in PowerShell.
2.  You will be prompted to enter the number of users to create.
3.  You will be prompted to enter the domain name (e.g., `company.com`).
4.  The script will then create the specified number of users in your Active Directory domain.

## Prerequisites

-   Windows machine with PowerShell.
-   Active Directory domain.
-   RSAT (Remote Server Administration Tools) for Active Directory installed (the script will attempt to install this if it is not already installed).
-   Appropriate permissions to create users in the Active Directory domain.

## Contributing

Feel free to contribute to this repository by submitting pull requests. Please ensure that your code is well-documented and follows best practices.

## License

This project is licensed under the [MIT License](LICENSE) - see the [LICENSE](LICENSE) file for details.

## Author

-   the2dl