package model; 

import java.math.BigDecimal;
import java.util.Date;

public class Reservation {
    private int reservationNumber;
    private Date dateMade;
    private int scheduleID;
    private int customerID;
    private int originID;
    private int destinationID;
    private String ticketType; // "adult", "child", "senior", "disabled"
    private String tripType;   // "one-way", "round-trip"
    private BigDecimal fare;   // Final fare after discounts and adjustments

    // Constructor
    public Reservation(int reservationNumber, Date dateMade, int scheduleID, int customerID, int originID, int destinationID, String ticketType, String tripType, BigDecimal fare) {
        this.reservationNumber = reservationNumber;
        this.dateMade = dateMade;
        this.scheduleID = scheduleID;
        this.customerID = customerID;
        this.originID = originID;
        this.destinationID = destinationID;
        this.ticketType = ticketType;
        this.tripType = tripType;
        this.fare = fare;
    }

    // Getters and Setters
    public int getReservationNumber() { return reservationNumber; }
    public void setReservationNumber(int reservationNumber) { this.reservationNumber = reservationNumber; }

    public Date getDateMade() { return dateMade; }
    public void setDateMade(Date dateMade) { this.dateMade = dateMade; }

    public int getScheduleID() { return scheduleID; }
    public void setScheduleID(int scheduleID) { this.scheduleID = scheduleID; }

    public int getCustomerID() { return customerID; }
    public void setCustomerID(int customerID) { this.customerID = customerID; }

    public int getOriginID() { return originID; }
    public void setOriginID(int originID) { this.originID = originID; }

    public int getDestinationID() { return destinationID; }
    public void setDestinationID(int destinationID) { this.destinationID = destinationID; }

    public String getTicketType() { return ticketType; }
    public void setTicketType(String ticketType) { this.ticketType = ticketType; }

    public String getTripType() { return tripType; }
    public void setTripType(String tripType) { this.tripType = tripType; }

    public BigDecimal getFare() { return fare; }
    public void setFare(BigDecimal fare) { this.fare = fare; }
}
