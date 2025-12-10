document.addEventListener('DOMContentLoaded', function () {
    const checkInInput = document.getElementById('check_in');
    const checkOutInput = document.getElementById('check_out');
    const serviceCheckboxes = document.querySelectorAll('.service-checkbox');
    const billSummary = document.getElementById('bill-summary');
    const roomPrice = parseFloat(document.getElementById('roomPrice').value);

    // validate ngay thang
    const today = new Date();
    today.setHours(0, 0, 0, 0);
    const todayString = today.toISOString().split('T')[0];
    checkInInput.setAttribute('min', todayString);

    checkInInput.addEventListener('change', function () {
        if (checkInInput.value) {
            let checkInDate = new Date(checkInInput.value);
            checkInDate.setDate(checkInDate.getDate() + 1);
            let minCheckOutDate = checkInDate.toISOString().split('T')[0];
            checkOutInput.setAttribute('min', minCheckOutDate);

            if (checkOutInput.value && checkOutInput.value <= checkInInput.value) {
                checkOutInput.value = '';
            }
        } else {
            checkOutInput.removeAttribute('min');
        }
        calculateBill();
    });


    serviceCheckboxes.forEach(checkbox => {
        const quantityInput = checkbox.closest('.col-md-6').querySelector('.service-quantity');
        checkbox.addEventListener('change', () => {
            quantityInput.style.display = checkbox.checked ? 'block' : 'none';
            if (!checkbox.checked) {
                quantityInput.value = '1';
            }
            calculateBill();
        });
        if (quantityInput) {
            quantityInput.addEventListener('input', calculateBill);
        }
    });

    checkOutInput.addEventListener('change', calculateBill);

    // tinh toan hoa don
    function calculateBill() {
        const checkInValue = checkInInput.value;
        const checkOutValue = checkOutInput.value;

        let numberOfNights = 0;
        if (checkInValue && checkOutValue && checkOutValue > checkInValue) {
            const startDate = new Date(checkInValue);
            const endDate = new Date(checkOutValue);
            const diffTime = Math.abs(endDate - startDate);
            numberOfNights = Math.ceil(diffTime / (1000 * 60 * 60 * 24));
        }

        const roomTotal = numberOfNights * roomPrice;

        let servicesTotal = 0;
        let servicesHtml = '';
        serviceCheckboxes.forEach(checkbox => {
            if (checkbox.checked) {
                const price = parseFloat(checkbox.dataset.price);
                const quantityInput = checkbox.closest('.col-md-6').querySelector('.service-quantity');
                const quantity = parseInt(quantityInput.value) || 1;
                const serviceName = checkbox.nextElementSibling.querySelector('strong').innerText;
                const serviceItemTotal = price * quantity;
                servicesTotal += serviceItemTotal;

                servicesHtml += `
                <div class="d-flex justify-content-between">
                    <span>${serviceName} (x${quantity})</span>
                    <span>${serviceItemTotal.toLocaleString('vi-VN')} VNĐ</span>
                </div>`;
            }
        });

        const grandTotal = roomTotal + servicesTotal;

        if (numberOfNights > 0) {
            billSummary.innerHTML = `
                <div class="d-flex justify-content-between">
                    <span>Tiền phòng (${numberOfNights} đêm)</span>
                    <strong>${roomTotal.toLocaleString('vi-VN')} VNĐ</strong>
                </div>
                ${servicesTotal > 0 ? '<hr>' : ''}
                ${servicesHtml}
                <hr>
                <div class="d-flex justify-content-between h4 mt-2">
                    <span>Tổng cộng</span>
                    <strong>${grandTotal.toLocaleString('vi-VN')} VNĐ</strong>
                </div>`;
        } else {
            billSummary.innerHTML = '<p class="text-muted">Vui lòng chọn ngày nhận và trả phòng hợp lệ.</p>';
        }
    }
});
