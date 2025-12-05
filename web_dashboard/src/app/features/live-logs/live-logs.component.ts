import { Component, OnDestroy, NgZone, signal } from '@angular/core';
import { NgClass, NgFor, NgIf } from '@angular/common';
import { interval, map, startWith, Subscription } from 'rxjs';
import { UiButtonComponent } from '../../shared/ui-button.component';
import { UiPillComponent } from '../../shared/ui-pill.component';

type LogLevel = 'INFO' | 'WARN' | 'ERROR' | 'DEBUG';

interface LogLine {
  level: LogLevel;
  message: string;
  timestamp: string;
}

@Component({
  selector: 'app-live-logs',
  standalone: true,
  imports: [NgFor, NgIf, NgClass, UiButtonComponent, UiPillComponent],
  templateUrl: './live-logs.component.html',
  styleUrls: ['./live-logs.component.scss']
})
export class LiveLogsComponent implements OnDestroy {
  logs = signal<LogLine[]>([]);
  running = true;
  private sub?: Subscription;

  constructor(private readonly zone: NgZone) {
    this.startStream();
  }

  ngOnDestroy() {
    this.stopStream();
  }

  toggle() {
    this.running ? this.stopStream() : this.startStream();
    this.running = !this.running;
  }

  clear() {
    this.logs.set([]);
  }

  private startStream() {
    this.sub = interval(1800)
      .pipe(
        startWith(0),
        map(() => this.randomLog())
      )
      .subscribe((log) => {
        this.zone.run(() => {
          this.logs.update((curr) => [...curr, log].slice(-200));
        });
      });
  }

  private stopStream() {
    this.sub?.unsubscribe();
    this.sub = undefined;
  }

  private randomLog(): LogLine {
    const levels: LogLevel[] = ['INFO', 'WARN', 'ERROR', 'DEBUG'];
    const level = levels[Math.floor(Math.random() * levels.length)];
    const messages = {
      INFO: [
        'Heartbeat ok',
        'Fetched 24 tickets',
        'Cache warm complete',
        'Email queue drained'
      ],
      WARN: [
        'Latency spiked to 480ms',
        'Retrying request to billing',
        'Slow query detected in ticket search'
      ],
      ERROR: [
        'Webhook delivery failed (502)',
        'Payment intent declined',
        'Redis connection reset'
      ],
      DEBUG: [
        'Polling interval set to 30s',
        'Feature flag check passed',
        'Token refreshed'
      ]
    } as const;
    const msgPool = messages[level];
    const message = msgPool[Math.floor(Math.random() * msgPool.length)];
    return {
      level,
      message,
      timestamp: new Date().toLocaleTimeString()
    };
  }

  levelClass(level: LogLevel) {
    return level;
  }

  pillClass(level: LogLevel) {
    switch (level) {
      case 'INFO':
        return 'bg-sky-500/15 text-sky-100 border border-sky-300/40';
      case 'WARN':
        return 'bg-amber-500/15 text-amber-100 border border-amber-300/40';
      case 'ERROR':
        return 'bg-rose-500/15 text-rose-100 border border-rose-300/40';
      case 'DEBUG':
        return 'bg-violet-500/15 text-violet-100 border border-violet-300/40';
    }
  }
}

