/**
 * The DMLOperations class serves as a deep dive into Data Manipulation Language (DML) in Apex.
 * It covers fundamental DML operations such as insert, update, upsert, and delete.
 *
 * This class introduces developers to the concept of manipulating Salesforce records in Apex.
 * It discusses how to use DML operations to create, update, and delete records.
 * This class uses standard Salesforce objects like Account, Contact, and Opportunity for demonstration.
 *
 * Topics covered in this class include:
 * - Understanding how to use insert DML operation to create records in Salesforce.
 * - Understanding how to use update and upsert DML operations to update existing records in Salesforce.
 * - Understanding how to use delete DML operation to remove records from Salesforce.
 *
 * Users of this class can expect to gain a strong understanding of DML operations in Apex and
 * be prepared for more advanced topics in Salesforce development.
 *
 * The methods within this class serve as practical examples of different DML operations,
 * allowing developers to learn through practice and examples.
 *
 * @author Terrence Gonsalves
 */


public with sharing class DMLOperations {

    /**
     * Question 1
     * Create a new Account object and inserts it into the database.
     * The Account will have a random name for uniqueness.
     * @return The Id of the newly created Account.
     */
    public static Id insertNewAccount() {

        // Create a new Account instance
        Account newAccount = new Account(Name = generateRandomName());

        // Set some fields on the Account
        newAccount.BillingCity = 'Ajax';
        newAccount.Industry = 'Dance';

        // Insert the Account into the database
        try {
            insert newAccount;
        } catch (DmlException e) {
            // do something about the error if one exist just want to start getting error catching ready
        }

        // Return the Id of the newly created Account
        return newAccount.Id;
    }

    /**
     * Question 2
     * Create a new Account with the specified name and industry provided.
     * @param name The name of the account to be created.
     * @param industry The industry of the account to be created.
     */
    public static void createAccount(String name, String industry) {
        // Create a new Account and set the fields inline
        Account newAccount = new Account(Name = name);
        newAccount.Industry = industry;

        // Insert the Account
        insert newAccount;
    }

    
    /**
     * Question 3
     * Create a new Contact and link it to the Account id provided then inserts it into the database.
     * @param accountId The Id of the Account to link the Contact to.
     * @return The Id of the newly created Contact.
     */
    public static Id insertNewContact(Id accountId) {
        // Create a new Contact instance
        Contact newContact = new Contact(FirstName = 'Jane', LastName = 'Doe');

        // Set some fields on the Contact
        // Set the AccountId field to the given accountId
        newContact.Title = 'Awesome Title';
        newContact.AccountId = accountId;

        // Insert the Contact into the database
        insert newContact;

        // Return the Id of the newly created Contact
        return newContact.Id;
    }

    /**
     * Question 4
     * Update the last name of a Contact in the database.
     * Resource: https://developer.salesforce.com/docs/atlas.en-us.soql_sosl.meta/soql_sosl/sforce_api_calls_soql.htm
     * @param contactId The Id of the Contact to update.
     * @param newLastName The new last name for the Contact.
     */
    public static void updateContactLastName(Id contactId, String newLastName) {
        // Retrieve the Contact from the database
        Contact updateContact = [SELECT Id FROM Contact WHERE Id = :contactId];

        // Update the Contact's last name
        updateContact.LastName = newLastName;

        // Update the Contact in the database
        update updateContact;
    }

    /**
     * Question 5
     * Update the stage of an Opportunity in the database.
     * Resource: https://developer.salesforce.com/docs/atlas.en-us.soql_sosl.meta/soql_sosl/sforce_api_calls_soql.htm
     * @param oppId The Id of the Opportunity to update.
     * @param newStage The new stage for the Opportunity.
     */
    public static void updateOpportunityStage(Id oppId, String newStage) {
        // Retrieve the Opportunity from the database
        Opportunity newOpportunity = [SELECT Id FROM Opportunity WHERE Id = :oppId];

        // Update the Opportunity's stage
        newOpportunity.StageName = newStage;

        // Update the Opportunity in the database
        update newOpportunity;
    }

    /**
     * Question 6
     * Update the Account's Name and Industry given an Account Id.
     * Resource: https://developer.salesforce.com/docs/atlas.en-us.soql_sosl.meta/soql_sosl/sforce_api_calls_soql.htm
     * @param accountId The Id of the account to be updated.
     * @param newName The new name for the account.
     * @param newIndustry The new industry for the account.
     */
    public static void updateAccountFields(Id accountId, String newName, String newIndustry) {
        // Query the account
        Account updateAccount = [SELECT Id FROM Account WHERE Id = :accountId];

        // Update the Account with the given Id with the new name and industry
        updateAccount.Name = newName;
        updateAccount.Industry = newIndustry;

        update updateAccount;
    }


    /**
     * Question 7
     * Create or updates an Opportunities
     * The Opportunity's Stage is set to Qualification.
     * The Opportunity's Close Date is set to 3 months from today.
     * The Opportunity's Amount is set to 50000.
     * @param list of Opportunities to be changed then upserted.
     */
    public static void upsertOpportunityList(List<Opportunity> opportunities) {
        List<Opportunity> upsertOpp = new List<Opportunity>();

        // Loop through each Opportunity in the list
            // Set the Opportunity's Stage to Qualification
            // Set the Opportunity's Close Date to 3 months from today
            // Set the Opportunity's Amount to 50000
        for (Opportunity opp : opportunities) {
            opp.StageName = 'Qualification';
            opp.CloseDate = Date.today().addMonths(3);
            opp.Amount = 50000;
        }

        // Upsert the opportunities List so that records are either updated or created (practising adding try/catch block)
        try {
            upsert opportunities;
        } catch (DmlException e) {
            // catch exception here
        }
    }

    /**
     * Question 8
     * Insert or updates opportunities from list of names.
     * Associate the Opportunities with account that has the name accountName.
     * There should be an Opportunity for each name provided in the list.
     * @param accountName The name of the Account.
     * @param oppNames The list of Opportunity names.
     */
    public static void upsertOpportunities(String accountName, List<String> oppNames) {
        Account newAccount = new Account(Name = accountName);

        try {
            insert newAccount;
        } catch (DmlException e) {
            // error trapping
        }

        // Loop through each Opportunity name
            // Create an Opportunity with the given name
            // Add the Opportunity to the list
        for (String name : oppNames) {
           Opportunity opp = new Opportunity();

           opp.Name = name;
           opp.StageName = 'Qualifications';
           opp.CloseDate = Date.today().addMonths(2);
           opp.AccountId = newAccount.Id;

           try {
            upsert opp;
           } catch (DmlException e) {
            System.debug('Error with upsert: ' + e);
           }
        }
    }
    
    /**
     * Question 9
	 * Upserts an Account with the specified name.
	 * If an Account with the given name already exists, update the description to "Updated Account".
	 * If no such Account exists, it creates a new one and sets the description to "New Account".
	 * @param accountName The name of the Account to be upserted.
	 * @return The Account that was upserted.
	 */
	public static Account upsertAccount(String accountName) {
		// Query for the Account
		List<Account> accounts = [SELECT Id FROM Account WHERE Name = :accountName WITH USER_MODE];
        Account acct = new Account(Name = accountName);
        String description;

		// if the Account exists, update the description
        if (!accounts.isEmpty()) {
            description = 'Updated Account';
        } else {
            description = 'New Account';
        }

        acct.Description = description;

		// otherwise, create a new Account and set the description

		// Upsert the Account
        try {
            upsert as user acct;
        } catch (DmlException e) {
            System.debug('Error with upsert: ' + e);
        }

		return acct;
	}

    /**
     * Question 10
	 * Manage the association between Contacts and Accounts
	 * Ensure that for each Contact in the provided list, there is a corresponding Account Name that matches the Contact's last name.
	 * If such an Account does not exist, the method creates it; if it does, the method ensures the Contact is associated with it. (Hint: use previous upsertAccount method - this may cause bad practices but for learning purposes it's okay.)
     * Example Contact.LastName = 'Doe' Link to Account.Name = 'Doe' 
     * Example Contact.LastName = 'Jane' Link to Account.Name = 'Jane'
	 * @param contactsToUpsert List of Contacts to be upserted and linked to accounts.
	 */
	public static void upsertAccountsWithContacts(List<Contact> contactsToUpsert) {
        Contact contactUpsert;

		// Loop through each Contact
        for (Contact contact : contactsToUpsert) {
            contactUpsert = new Contact(LastName = contact.LastName, FirstName = contact.FirstName);

            // Extract the Account Name from Contact's LastName
            //String accountName = contact.LastName;

            // Get the account based on the name or create one if it doesn't exist
		    Account[] account = [SELECT Id FROM Account WHERE Name = :contact.LastName WITH USER_MODE];


            // Link the Contact to its Account using the Account Id

            if (account.size() > 0) {
                contactUpsert.AccountId = account[0].Id;
            } else {

                // Account doesn't exist lets create one and link Contact
                Account newContactAcount = new Account(Name = contact.LastName);
		        insert as user newContactAcount;

                contactUpsert.AccountId = newContactAcount.Id;
            }

            try {
                upsert as user contactUpsert;
            } catch (DmlException e) {
                System.debug('There has been an DML error: ' + e);
            }
        }
	}

    /**
     * Question 11
     * Insert a list of Leads and then deletes them.
     * @param leadNames The list of Lead names to be inserted.
     */
    public static void insertAndDeleteLeads(List<String> leadNames) {
        List<Lead> listTempLead = new List<Lead>();

        // Loop through each Lead name
        for (String leadName : LeadNames) {
            Lead newTempLead = new Lead(LastName = leadName, Company = 'Company Name', Status = 'Open - Not Contacted');
            listTempLead.add(newTempLead);
        }

        // Insert the Leads
        insert listTempLead;

        // Delete the Leads
        delete listTempLead;
    }


    /**
     * Question 12
     * Dynamically create the number of cases and relate it to the accountId, then deletes them.
     * @param accountId The account for which the cases will be created and then deleted.
     * @param numOfCases The number of cases to create.
     */
    public static void createAndDeleteCases(String accountId, Integer numOfCases) {
        List<Case> tempCase = new List<Case>();

        for (Integer x = 0; x < numOfCases; x++) {
            Case newTempCase = new Case(AccountId = accountId, Status = 'New', Origin = 'Email');
            tempCase.add(newTempCase);
        }
        
        // Insert the cases
        insert tempCase;

        // Delete the cases
        delete tempCase;
    }

    /**
     * Private method that generates and randon name for a new account thooughout these tests
     *  
     * @return The random name to be used
     */
    private static String generateRandomName() {
        List<String> randomName1 = new List<String> { 
            'ethereal',
            'whimsical',
            'ambitious',
            'smelly',
            'wacky',
            'several',
            'savory',
            'rigid',
            'impartial',
            'lying'
        };
        List<String> randomName2 = new List<String> { 
            'system',
            'session',
            'product',
            'proposal',
            'youth',
            'sister',
            'attitude',
            'bedroom',
            'vehicle',
            'departure'
        };
        String randomName = '';

        randomName = randomName1.get((Integer) Math.random() * randomName1.size()).capitalize() + ' ' + randomName2.get((Integer) Math.random() * randomName2.size()).capitalize();
        
        return randomName; 
    }
}