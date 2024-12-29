# Script Name: User Creation Script
# Author: the2dl
# Description: This script creates multiple Active Directory users with randomized attributes.
# It generates usernames, passwords, and other user details, and logs the process.

# Import required module for AD operations
Import-Module ActiveDirectory

# Enable verbose output
$VerbosePreference = "Continue"

# Arrays for realistic name generation
$firstNames = @(
    "James", "John", "Robert", "Michael", "William", "David", "Richard", "Joseph",
    "Mary", "Patricia", "Jennifer", "Linda", "Elizabeth", "Barbara", "Susan", "Jessica",
    "Thomas", "Charles", "Christopher", "Daniel", "Matthew", "Anthony", "Donald", "Mark",
    "Paul", "Steven", "Andrew", "Kenneth", "George", "Joshua", "Kevin", "Brian",
    "Margaret", "Dorothy", "Lisa", "Nancy", "Karen", "Betty", "Helen", "Sandra",
    "Ashley", "Kimberly", "Emily", "Donna", "Michelle", "Carol", "Amanda", "Melissa",
    "Deborah", "Stephanie", "Eric", "Gary", "Timothy", "Larry", "Jeffrey", "Frank",
    "Scott", "Justin", "Brandon", "Raymond", "Gregory", "Alice", "Angela", "Sarah",
    "Nicole", "Katherine", "Brenda", "Amy", "Virginia", "Pamela", "Samantha", "Ruth",
    "Shirley", "Rachel", "Evelyn", "Judith", "Theresa", "Cheryl", "Sophia", "Olivia",
    "Isabella", "Mia", "Abigail", "Madison", "Charlotte", "Harper", "Avery", "Ella",
    "Amelia", "Lily", "Chloe", "Penelope", "Riley", "Grace", "Nora", "Hazel", "Zoe",
    "Aurora", "Scarlett", "Violet", "Maya", "Naomi", "Claire", "Audrey", "Hannah",
    "Addison", "Leah", "Savannah", "Brooklyn", "Bella", "Elena", "Gabriella", "Anna",
    "Camila", "Ariana", "Maria", "Lucy", "Stella", "Paisley", "Eva", "Genesis", "Emilia",
    "Kennedy", "Samantha", "Madelyn", "Eleanor", "Caroline", "Willow", "Kinsley", "Ruby",
    "Sophie", "Ivy", "Allison", "Taylor", "Natalie", "Daisy", "Kaylee", "Lydia", "Aubrey",
    "Sarah", "Erin", "Megan", "Lauren", "Jordan", "Morgan", "Haley", "Sydney", "Brooke",
    "Julia", "Paige", "Mackenzie", "Angelina", "Victoria", "Alexandra", "Brianna", "Jasmine",
    "Kayla", "Andrea", "Maria", "Diana", "Chelsea", "Amber", "Katie", "Vanessa", "Jenna",
    "Autumn", "Summer", "Skylar", "Trinity", "Destiny", "Hope", "Faith", "Angel", "Joy",
    "Lyric", "Harmony", "Melody", "Heaven", "Nevaeh", "Serenity", "Justice", "Miracle",
    "Legend", "Phoenix", "River", "Hunter", "Dakota", "Reese", "Rowan", "Skyler", "Remi",
    "Blake", "Casey", "Riley", "Quinn", "Avery", "Emerson", "Finley", "Hayden", "Indigo",
    "Logan", "Parker", "Peyton", "Reagan", "Sawyer", "Teagan", "Arden", "Blair", "Cameron",
    "Drew", "Jamie", "Jordan", "Kai", "Lane", "Micah", "Noel", "Rory", "Sage", "Shiloh",
    "Tatum", "Wren"
)

$lastNames = @(
    "Smith", "Johnson", "Williams", "Brown", "Jones", "Garcia", "Miller", "Davis",
    "Rodriguez", "Martinez", "Hernandez", "Lopez", "Gonzalez", "Wilson", "Anderson",
    "Taylor", "Moore", "Jackson", "Martin", "Lee", "Perez", "Thompson", "White", "Harris",
    "Sanchez", "Clark", "Ramirez", "Lewis", "Robinson", "Walker", "Young", "Allen",
    "King", "Wright", "Scott", "Torres", "Nguyen", "Hill", "Flores", "Green",
    "Adams", "Nelson", "Baker", "Hall", "Rivera", "Campbell", "Mitchell", "Carter",
    "Roberts", "Phillips", "Evans", "Turner", "Parker", "Collins", "Edwards", "Stewart",
    "Flores", "Morris", "Murphy", "Cook", "Rogers", "Morgan", "Peterson", "Cooper",
    "Reed", "Bailey", "Bell", "Gomez", "Kelly", "Howard", "Ward", "Cox", "Diaz",
    "Richardson", "Wood", "Watson", "Brooks", "Bennett", "Gray", "James", "Reyes",
    "Cruz", "Hughes", "Price", "Myers", "Long", "Foster", "Sanders", "Ross", "Morales",
    "Powell", "Sullivan", "Russell", "Ortiz", "Jenkins", "Gutierrez", "Perry", "Butler",
    "Barnes", "Fisher", "Henderson", "Coleman", "Simmons", "Patterson", "Jordan",
    "Reynolds", "Hamilton", "Graham", "Kim", "Gonzales", "Alexander", "Ramos", "Wallace",
    "Griffin", "West", "Cole", "Hayes", "Chavez", "Gibson", "Bryant", "Carr", "Mcdonald",
    "Hicks", "Marshall", "Wells", "Stone", "Lucas", "Frazier", "Dunn", "Boyd", "Stephens",
    "Mccarthy", "Hanson", "Arnold", "Lane", "Dale", "Shaw", "Ryan", "Black", "Porter",
    "Griffin", "Montgomery", "Fuller", "Weaver", "Nichols", "Meyers", "Ford", "Hamilton",
    "Harvey", "Kennedy", "Lawson", "Owens", "Dean", "Dawson", "Woods", "Hunt", "Arnold",
    "Gordon", "Hunter", "Hart", "Bradley", "Carroll", "Daniels", "Austin", "Johnston",
    "Knight", "Ferguson", "Rose", "Stone", "Palmer", "Pearson", "Gregory", "Little",
    "Warren", "Simpson", "Hale", "Johns", "Murray", "Walsh", "Benson", "Fowler", "Bowman",
    "Boyce", "Bradshaw", "Brewer", "Bridges", "Burke", "Byrd", "Cain", "Calhoun", "Cannon",
    "Carey", "Carlson", "Carpenter", "Case", "Castillo", "Castro", "Chambers", "Chapman",
    "Christensen", "Clayton", "Clements", "Cleveland", "Cline", "Cobb", "Coffey", "Cohen",
    "Conner", "Conway", "Cooke", "Cortez", "Crane", "Crawford", "Cummings", "Curtis",
    "Dalton", "Davidson", "Day", "Decker", "Delgado", "Dennis", "Dickerson", "Dixon",
    "Dodd", "Donovan", "Douglas", "Downs", "Doyle", "Drake", "Dudley", "Duncan", "Eaton",
    "Erickson", "Espinoza", "Estes", "Farrell", "Faulkner", "Fields", "Finley", "Fitzgerald",
    "Fleming", "Fletcher", "Flynn", "Forbes", "Ford", "Fox", "Francis", "Franklin",
    "Freeman", "Frost", "Frye", "Gaines", "Gallegos", "Galloway", "Gardner", "Garner",
    "Garrett", "Gates", "Gay", "George", "Gibbs", "Gilbert", "Giles", "Gill", "Glover",
    "Golden", "Goodman", "Goodwin", "Grant", "Graves", "Gray", "Greene", "Griffin",
    "Gross", "Hahn", "Haley", "Hall", "Hamilton", "Hammond", "Hampton", "Hancock",
    "Haney", "Hansen", "Hardin", "Hardy", "Harman", "Harper", "Hartman", "Harvey",
    "Hawkins", "Hayden", "Hayes", "Haynes", "Heath", "Heller", "Hendricks", "Henry",
    "Hensley", "Herman", "Hess", "Hewitt", "Higgins", "Hines", "Hobbs", "Hodge",
    "Hoffman", "Hogan", "Holcomb", "Holland", "Holloway", "Holmes", "Holt", "Hooper",
    "Hopkins", "Horn", "Horton", "House", "Houston", "Howard", "Howell", "Hubbard",
    "Hudson", "Huff", "Huffman", "Hughes", "Hull", "Humphrey", "Hunt", "Hunter",
    "Hurst", "Hutchinson", "Ingram", "Irwin", "Jackson", "Jacobs", "James", "Jefferson",
    "Jenkins", "Jennings", "Jensen", "Jewell", "Johns", "Johnson", "Johnston", "Jones",
    "Jordan", "Joseph", "Joyce", "Justice", "Kane", "Kaufman", "Keaton", "Keller",
    "Kelley", "Kelly", "Kemp", "Kendall", "Kennedy", "Kent", "Kerr", "Key", "Khan",
    "Kidd", "Kim", "King", "Kirby", "Kirk", "Klein", "Knight", "Knox", "Koch", "Kramer",
    "Lamb", "Lambert", "Lancaster", "Landry", "Lane", "Lang", "Larson", "Lawrence",
    "Lawson", "Leach", "Lee", "Leonard", "Lester", "Levine", "Lewis", "Lindsey",
    "Little", "Lloyd", "Locke", "Logan", "Long", "Lopez", "Love", "Lowe", "Lucas",
    "Lynch", "Lynn", "Lyons", "Macdonald", "Mack", "Madden", "Maddox", "Maldonado",
    "Malone", "Mann", "Manning", "Marks", "Marsh", "Marshall", "Martin", "Martinez",
    "Mason", "Massey", "Mathews", "Mathis", "Matthews", "Maxwell", "May", "Mayer",
    "Maynard", "Mccall", "Mccann", "Mccarthy", "Mccormick", "Mccoy", "Mcdaniel",
    "Mcdonald", "Mcdowell", "Mcgee", "Mcguire", "Mcintosh", "Mckay", "Mckee", "Mckenzie",
    "Mckinney", "Mclaughlin", "Mclean", "Mcmillan", "Mcneil", "Mcpherson", "Mead",
    "Medina", "Mejia", "Melendez", "Melton", "Mendez", "Mercer", "Merrill", "Meyers",
    "Michael", "Middleton", "Miles", "Miller", "Mills", "Mitchell", "Monroe",
    "Montes", "Montgomery", "Moody", "Moon", "Moore", "Morales", "Moreno", "Morgan",
    "Morris", "Morrison", "Morse", "Morton", "Moses", "Mosley", "Mueller", "Mullins",
    "Munoz", "Murphy", "Murray", "Myers", "Nash", "Neal", "Nelson", "Newman",
    "Newton", "Nguyen", "Nichols", "Nicholson", "Nixon", "Noble", "Noel", "Norman",
    "Norris", "Norton", "Nunez", "O'brien", "O'connor", "O'donnell", "O'neal",
    "O'neill", "Oliver", "Olsen", "Olson", "Ortega", "Osborn", "Osborne", "Owen",
    "Owens", "Pace", "Page", "Palmer", "Park", "Parker", "Parks", "Parrish",
    "Parsons", "Patel", "Patrick", "Patterson", "Patton", "Paul", "Payne", "Peacock",
    "Pearce", "Pearson", "Pena", "Pennington", "Perez", "Perkins", "Perry",
    "Peters", "Peterson", "Petty", "Phelps", "Phillips", "Pickett", "Pierce",
    "Pittman", "Pollard", "Poole", "Pope", "Porter", "Potter", "Powell", "Powers",
    "Pratt", "Preston", "Price", "Prince", "Pruitt", "Puckett", "Quinn", "Rader",
    "Raines", "Ramirez", "Ramos", "Ramsey", "Randall", "Randolph", "Rasmussen",
    "Ratliff", "Ray", "Raymond", "Reed", "Reese", "Reeves", "Reid", "Reilly",
    "Reyes", "Reynolds", "Rhodes", "Rice", "Rich", "Richard", "Richards",
    "Richardson", "Richmond", "Riddle", "Riggs", "Riley", "Rios", "Rivas",
    "Rivera", "Roach", "Robbins", "Roberts", "Robertson", "Robinson", "Rodgers",
    "Rodriguez", "Rogers", "Rollins", "Romero", "Rose", "Ross", "Rowe", "Rowland",
    "Roy", "Ruiz", "Rush", "Russell", "Ryan", "Salas", "Salazar", "Salgado",
    "Sampson", "Sanchez", "Sanders", "Sandoval", "Sanford", "Santana", "Santiago",
    "Santos", "Sargent", "Saunders", "Savage", "Sawyer", "Schmidt", "Schneider",
    "Schroeder", "Schultz", "Scott", "Sears", "Seaton", "Sellers", "Serrano",
    "Sexton", "Shaffer", "Shannon", "Sharp", "Shaw", "Shelton", "Shepard",
    "Shepherd", "Sherman", "Shields", "Short", "Simmons", "Simon", "Simpson",
    "Sims", "Sinclair", "Singleton", "Skinner", "Slater", "Sloan", "Small",
    "Smart", "Smith", "Snider", "Snow", "Snyder", "Solis", "Solomon", "Sommers",
    "Sosa", "Soto", "Sparks", "Spears", "Spencer", "Spicer", "Springer",
    "Stafford", "Stanley", "Stanton", "Stark", "Steele", "Stein", "Stephens",
    "Stephenson", "Stevens", "Stevenson", "Stewart", "Stokes", "Stone",
    "Stout", "Strickland", "Strong", "Stuart", "Sullivan", "Summers",
    "Sutton", "Swanson", "Sweeney", "Sweet", "Sykes", "Tabor", "Tanner",
    "Tate", "Taylor", "Terrell", "Terry", "Thacker", "Thames", "Thomas",
    "Thompson", "Thornton", "Tillman", "Todd", "Tomlinson", "Torres",
    "Townsend", "Tran", "Travis", "Trevino", "Trujillo", "Tucker",
    "Turner", "Tyler", "Underwood", "Valdez", "Valentine", "Valenzuela",
    "Vance", "Vargas", "Vasquez", "Vaughan", "Vaughn", "Vega", "Velazquez",
    "Velez", "Vera", "Vernon", "Vick", "Vincent", "Vinson", "Wade",
    "Wagner", "Walker", "Wall", "Wallace", "Waller", "Walls", "Walsh",
    "Walter", "Walters", "Walton", "Ward", "Ware", "Warner", "Warren",
    "Washington", "Waters", "Watkins", "Watson", "Watts", "Weaver",
    "Webb", "Weber", "Webster", "Weeks", "Weiss", "Welch", "Wells",
    "West", "Weston", "Wheeler", "Whitaker", "White", "Whitehead",
    "Whitfield", "Whitley", "Whitney", "Wiggins", "Wilcox", "Wilder",
    "Wiley", "Wilkerson", "Wilkins", "Williams", "Williamson", "Willis",
    "Wilson", "Winters", "Wise", "Witt", "Wolf", "Wolfe", "Wood",
    "Woodard", "Woods", "Woodward", "Wooten", "Workman", "Wright",
    "Wyatt", "Wynn", "Yates", "York", "Young", "Zamora", "Zimmerman"
)

$departments = @("IT", "HR", "Finance", "Marketing", "Sales", "Operations", "Legal")
$offices = @("New York", "Los Angeles", "Chicago", "Houston", "Phoenix", "Philadelphia")

# Get input from user
$numUsers = Read-Host "Enter the number of users to create"
$domain = Read-Host "Enter the domain name (e.g., company.com)"

# Validate inputs
if (-not ($numUsers -match '^\d+$')) {
    Write-Error "Please enter a valid number"
    exit
}

# Function to generate random phone number
function Get-RandomPhoneNumber {
    return "(" + (Get-Random -Minimum 200 -Maximum 999) + ") " + 
           (Get-Random -Minimum 100 -Maximum 999) + "-" + 
           (Get-Random -Minimum 1000 -Maximum 9999)
}

# Function to generate a random password
function Get-RandomPassword {
    $length = 12
    $characters = 'abcdefghkmnprstuvwxyzABCDEFGHKLMNPRSTUVWXYZ123456789!@#$%^&*'
    $password = -join ((Get-Random -Count $length -InputObject $characters.ToCharArray()))
    return $password + "Aa1!"  # Ensure password complexity requirements
}

# Add new logging function
function Write-LogMessage {
    param(
        [string]$Message,
        [string]$Level = "Info"
    )
    # Get current timestamp for log entry
    $timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
    # Construct log message with timestamp and level
    $logMessage = "[$timestamp] [$Level] $Message"
    
    # Write to console with appropriate color
    switch ($Level) {
        "Error"   { Write-Host $logMessage -ForegroundColor Red }
        "Warning" { Write-Host $logMessage -ForegroundColor Yellow }
        "Success" { Write-Host $logMessage -ForegroundColor Green }
        default   { Write-Host $logMessage }
    }
    
    # Also write to log file
    $logMessage | Out-File -FilePath ".\user_creation.log" -Append
}

# Test AD connectivity first
try {
    $domainObj = Get-ADDomain
    Write-Host "Successfully connected to domain: $($domainObj.DNSRoot)" -ForegroundColor Green
}
catch {
    Write-Error "Failed to connect to Active Directory: $_"
    Write-Host "Attempting to install RSAT tools..."
    try {
        Add-WindowsCapability -Online -Name Rsat.ActiveDirectory.DS-LDS.Tools~~~~0.0.1.0 -ErrorAction Stop
        Write-Host "RSAT tools installed successfully. Please re-run the script." -ForegroundColor Green
    }
    catch {
        Write-Error "Failed to install RSAT tools: $_"
    }
    exit
}

# Add a counter for successful creations
$successfulCreations = 0

# Modified main loop to continue until we reach desired number of users
while ($successfulCreations -lt $numUsers) {
    $firstName = $firstNames | Get-Random
    $lastName = $lastNames | Get-Random
    $department = $departments | Get-Random
    $office = $offices | Get-Random
    
    # Generate username (first initial + lastname)
    $username = ($firstName.Substring(0,1) + $lastName).ToLower()
    
    # Generate email
    $email = "$username@$domain"
    
    # Generate random password
    $password = Get-RandomPassword
    $securePassword = ConvertTo-SecureString $password -AsPlainText -Force
    
    Write-Verbose "Attempting to create user: $username"
    
    try {
        # Check if user already exists
        if (Get-ADUser -Filter "SamAccountName -eq '$username'") {
            Write-LogMessage "Username $username is taken, trying another combination..." "Info"
            continue
        }

        # Create new user with error handling
        $params = @{
            Name = "$firstName $lastName"
            GivenName = $firstName
            Surname = $lastName
            SamAccountName = $username
            UserPrincipalName = $email
            AccountPassword = $securePassword
            Enabled = $true
            ChangePasswordAtLogon = $true
            ErrorAction = "Stop"
        }

        Write-LogMessage "Creating user: $username" "Info"
        New-ADUser @params

        # Update additional properties with error handling
        $userParams = @{
            Identity = $username
            EmailAddress = $email
            Title = "Employee"
            Department = $department
            Office = $office
            Company = ($domain -split '\.')[0]
            OfficePhone = (Get-RandomPhoneNumber)
            ErrorAction = "Stop"
        }

        Set-ADUser @userParams
        Write-LogMessage "Created user: $username | Name: $firstName $lastName | Password: $password" "Success"
        $successfulCreations++
        Write-LogMessage "Progress: $successfulCreations/$numUsers users created" "Info"
    }
    catch {
        Write-LogMessage "Failed to create user: $username" "Error"
        Write-LogMessage "Error details: $($_.Exception.Message)" "Error"
        
        if ($_.Exception.InnerException) {
            Write-LogMessage "Inner Exception: $($_.Exception.InnerException.Message)" "Error"
        }
        
        Start-Sleep -Seconds 2
    }
}

Write-Host "`nUser creation complete!" -ForegroundColor Green