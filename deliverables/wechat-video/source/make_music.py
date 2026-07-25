#!/usr/bin/env python3
"""Generate a quiet original ambient bed for the portfolio video."""

import math
import random
import struct
import wave
from pathlib import Path

SAMPLE_RATE = 44_100
DURATION = 44.0
OUTPUT = Path(__file__).resolve().parent / "ambient-bed.wav"


def envelope(t: float, start: float, length: float) -> float:
    local = t - start
    if local < 0 or local > length:
        return 0.0
    attack = min(1.0, local / 0.18)
    release = min(1.0, (length - local) / 1.2)
    return attack * release


def note(t: float, start: float, length: float, frequency: float) -> float:
    env = envelope(t, start, length)
    local = max(0.0, t - start)
    fundamental = math.sin(2 * math.pi * frequency * local)
    overtone = 0.32 * math.sin(2 * math.pi * frequency * 2.01 * local)
    shimmer = 0.12 * math.sin(2 * math.pi * frequency * 3.99 * local)
    return env * (fundamental + overtone + shimmer)


def main() -> None:
    random.seed(365)
    chords = [
        (0.0, (220.00, 277.18, 329.63)),
        (7.0, (196.00, 246.94, 293.66)),
        (14.0, (174.61, 220.00, 261.63)),
        (21.0, (196.00, 246.94, 329.63)),
        (28.0, (220.00, 277.18, 329.63)),
        (35.0, (196.00, 246.94, 293.66)),
        (42.0, (220.00, 277.18, 329.63)),
    ]

    with wave.open(str(OUTPUT), "wb") as audio:
        audio.setnchannels(2)
        audio.setsampwidth(2)
        audio.setframerate(SAMPLE_RATE)

        for index in range(int(SAMPLE_RATE * DURATION)):
            t = index / SAMPLE_RATE
            value = 0.0

            for start, frequencies in chords:
                for frequency in frequencies:
                    value += 0.055 * note(t, start, 8.0, frequency)

            pulse_start = math.floor(t / 2.0) * 2.0
            pulse_frequency = 440.0 if int(pulse_start / 2) % 2 == 0 else 392.0
            value += 0.035 * note(t, pulse_start, 1.8, pulse_frequency)

            noise = (random.random() * 2.0 - 1.0) * 0.002
            fade_in = min(1.0, t / 1.5)
            fade_out = min(1.0, (DURATION - t) / 2.5)
            value = max(-0.95, min(0.95, (value + noise) * fade_in * fade_out))

            left = int(value * 32767)
            right = int(value * 0.92 * 32767)
            audio.writeframesraw(struct.pack("<hh", left, right))

    print(OUTPUT)


if __name__ == "__main__":
    main()
