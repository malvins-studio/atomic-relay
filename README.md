# Atomic Relay

Atomic Relay is a self-hosted messaging gateway that uses real devices as delivery nodes.

It allows any connected device to act as a message provider. The current implementation focuses on SMS using Android devices, but the system is designed to support multiple transport layers.

## Why this exists

Most messaging infrastructure depends on external providers such as Twilio or Amazon SNS. These services offer strong guarantees, but introduce cost, dependency, and operational constraints.

Atomic Relay takes a different approach.

Instead of outsourcing delivery, it uses devices you control.

This makes it suitable for:

* small systems where cost matters
* environments with limited infrastructure
* applications that require full ownership of the messaging layer

It is not a replacement for enterprise-grade providers. It is an alternative for systems that value control and simplicity over scale.

## How it works

Atomic Relay is composed of two parts:

```sh
                ┌────────────────────┐
                │    Rails Server    │
                │  + Solid Queue     │
                │  + WebSocket Hub   │
                └────────┬───────────┘
                         │
        ┌────────────────┼────────────────┐
        │                │                │
 ┌────────────┐   ┌────────────┐   ┌────────────┐
 │   Android  │   │  Android   │   │   Android  │
 │  (Worker)  │   │  (Worker)  │   │  (Worker)  │
 └────────────┘   └────────────┘   └────────────┘
```

### Server

The server is responsible for:

* receiving message requests
* storing and tracking message state
* assigning jobs to connected workers

It acts as the control plane of the system.

### Worker

A worker is a device connected to the server over WebSocket.

Each worker:

* declares its capabilities (e.g. SMS via Android)
* receives jobs from the server
* executes delivery
* reports results

In the current setup, a worker runs on an Android device using Termux and sends SMS through the device's SIM card.

## Architecture

* The server maintains a queue of messages
* Workers connect and remain online
* Messages are assigned to available workers
* Delivery results are reported back and persisted

Workers are treated as disposable nodes. The server is the source of truth.

## Current capabilities

* SMS delivery via Android devices
* WebSocket-based communication
* Basic job queue and status tracking

## Limitations

* No delivery guarantees
* Dependent on device availability and network conditions
* Scaling requires additional devices
* Subject to carrier restrictions and SIM limits

## Roadmap

* multiple worker support with load distribution
* retry and backoff strategies
* pluggable transport adapters (email, WhatsApp, others)
* improved observability and logging

## Philosophy

Atomic Relay is part of the Atomic Apps ecosystem.

Each component is:

* small
* understandable
* replaceable

The goal is not to compete with large infrastructure providers, but to offer a simple, self-hosted foundation that can evolve as needed.
