/*
 * Unless explicitly stated otherwise all files in this repository are licensed under the Apache License Version 2.0.
 * This product includes software developed at Datadog (https://www.datadoghq.com/).
 * Copyright 2019-2020 Datadog, Inc.
 */

import CoreTelephony

/*
A collection of mocks for different `CoreTelephony` types.
It follows the mocking conventions described in `FoundationMocks.swift`.
 */

#if os(iOS)
class CTCarrierMock: CTCarrier {
    private let _carrierName: String?
    private let _isoCountryCode: String?
    private let _allowsVOIP: Bool

    init(carrierName: String, isoCountryCode: String, allowsVOIP: Bool) {
        _carrierName = carrierName
        _isoCountryCode = isoCountryCode
        _allowsVOIP = allowsVOIP
    }

    override var carrierName: String? { _carrierName }
    override var isoCountryCode: String? { _isoCountryCode }
    override var allowsVOIP: Bool { _allowsVOIP }
}

class CTTelephonyNetworkInfoMock: CTTelephonyNetworkInfo {
    private let _serviceCurrentRadioAccessTechnology: [String: String]?
    private let _serviceSubscriberCellularProviders: [String: CTCarrier]?

    init(
        serviceCurrentRadioAccessTechnology: [String: String],
        serviceSubscriberCellularProviders: [String: CTCarrier]
    ) {
        _serviceCurrentRadioAccessTechnology = serviceCurrentRadioAccessTechnology
        _serviceSubscriberCellularProviders = serviceSubscriberCellularProviders
    }

    override var serviceCurrentRadioAccessTechnology: [String: String]? { _serviceCurrentRadioAccessTechnology }
    override var serviceSubscriberCellularProviders: [String: CTCarrier]? { _serviceSubscriberCellularProviders }
}
#endif
