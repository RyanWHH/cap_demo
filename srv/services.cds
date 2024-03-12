using { sap.capire.bookstore as db } from '../db/schema';

service AdminService {
    entity Products   as projection on db.Products;
    entity Categories as projection on db.Categories;
}


// Define Books Service
service BooksService {
    @readonly entity Books as projection   on db.Books { *, category as genre } excluding { category, createdBy, createdAt, modifiedBy, modifiedAt };
    @readonly entity Authors as projection on db.Authors;
}

// Define Orders Service
service OrdersService {
    @(restrict: [
        { grant: '*', to: 'Administrators' },
        { grant: '*', where: 'createdBy = $user' }
    ])
    entity Orders as projection on db.Orders;

    @(restrict: [
        { grant: '*', to: 'Administrators' },
        { grant: '*', where: 'parent.createdBy = $user' }
    ])
    entity OrderItems as projection on db.OrderItems;
}

// Reuse Admin Service
extend service AdminService with {
    entity Authors as projection on db.Authors;
}


annotate AdminService @(requires: 'Administrators');