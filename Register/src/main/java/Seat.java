import java.math.BigDecimal;

public class Seat {
	private String zone;
    private String section;
    private int rowNo;
    private int seatNumber;
    private String seatType;
    private BigDecimal price;
    private String status;

    public Seat(String zone, String section, int rowNo, int seatNumber, String seatType, BigDecimal price, String status) {
        this.zone = zone;
        this.section = section;
        this.rowNo = rowNo;
        this.seatNumber = seatNumber;
        this.seatType = seatType;
        this.price = price;
        this.status = status;
    }

    // Getters
    public String getZone() {
        return zone;
    }

    public String getSection() {
        return section;
    }

    public int getRowNo() {
        return rowNo;
    }

    public int getSeatNumber() {
        return seatNumber;
    }

    public String getSeatType() {
        return seatType;
    }

    public BigDecimal getPrice() {
        return price;
    }

    public String getStatus() {
        return status;
    }

}
